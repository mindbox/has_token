require 'token'

module HasToken
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_token(*args)
      options = args.extract_options!.symbolize_keys
      options.merge!(
        :column => args.first || :token
      ).reverse_merge!(
        :length => 6,
        :characters => [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).sum,
        :constructor => proc(&:generate_token),
        :to_param => false,
        :readonly => true
      )

      class_inheritable_accessor :has_token_options
      return false unless self.has_token_options.nil?
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

      has_one :global_token, :class_name => 'Token', :as => :parent, :dependent => :nullify

      include InstanceMethods

      before_create :create_token
    end
  end

  module InstanceMethods
    private
      def generate_token
        Array.new(has_token_options[:length]){ has_token_options[:characters].rand }.join
      end

      def create_token
        column = has_token_options[:column]
        value = read_attribute(column)

        if value
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
          write_attribute(column, value)
        end
      end
  end
end

ActiveRecord::Base.send(:include, HasToken)
