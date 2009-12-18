%w(configuration token).each do |f|
  require File.join(File.dirname(__FILE__), 'has_token', f)
end

module HasToken
  class << self
    def configure
      yield Configuration
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_token(*args)
      options = args.extract_options!.symbolize_keys
      options.reverse_merge!(HasToken::Configuration.options)
      options.merge!(
        :column => args.first || :token
      ).reverse_merge!(
        :length => 6,
        :characters => [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).sum,
        :constructor => proc(&:generate_token),
        :to_param => false,
        :readonly => true,
        :dependent => :nullify,
        :callback => :before_create
      )

      class_inheritable_accessor :has_token_options
      return false unless has_token_options.nil?
      self.has_token_options = options

      if options[:to_param]
        define_method(:to_param_with_token) do
          read_attribute(options[:column])
        end
        alias_method_chain :to_param, :token
      end

      if options[:readonly]
        attr_readonly(options[:column])
      end

      has_one :global_token, :class_name => 'Token', :as => :parent, :dependent => options[:dependent]

      include InstanceMethods

      send has_token_options[:callback], :create_token
    end
  end

  module InstanceMethods
    private
      def generate_token
        Array.new(has_token_options[:length]){ has_token_options[:characters].rand }.join
      end

      def create_token
        column = has_token_options[:column]

        if value = read_attribute(column)
          token = build_global_token(:value => value)
          unless token.save
            errors.add(column, token.errors.on(:value))
            return false
          end
        else
          begin
            value = has_token_options[:constructor].call(self)
            token = build_global_token(:value => value)
          end until token.save

          set_token(value)
        end
      end

      def set_token(value)
        case has_token_options[:callback].to_s
          when /(find|initialize|destroy)$/ then nil
          when /validation/, /^before/
            write_attribute(has_token_options[:column], value)
          else
            write_attribute(has_token_options[:column], value)
            update_without_dirty([has_token_options[:column]])
        end
      end
  end
end

ActiveRecord::Base.send(:include, HasToken)
