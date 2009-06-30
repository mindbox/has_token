require 'token'

module LaserLemon
  module HasToken
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_token(column, options = {})
        options.reverse_merge!(
          :column => column,
          :length => 6,
          :characters => [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).sum,
          :to_param => false,
          :readonly => true
        )
        
        cattr_accessor :has_token_options
        return(false) if self.has_token_options.present?
        self.has_token_options = options
        
        attr_readonly(column) if options[:readonly]
        define_method(:to_param){ read_attribute(column) } if options[:to_param]
        
        has_one :global_token, :class_name => 'Token', :as => :parent, :autosave => true
        
        include InstanceMethods
        before_create :set_token
      end
    end
    
    module InstanceMethods
      def has_token_options
        self.class.has_token_options
      end
      
      def set_token
        begin
          token_value = case
          when has_token_options[:constructor].is_a?(Proc): has_token_options[:constructor].call(self)
          else Array.new(has_token_options[:length]){ has_token_options[:characters].rand }.join
          end
        end while Token.exists?(:value => token_value)
        build_global_token(:value => token_value)
        write_attribute(has_token_options[:column], token_value)
      end
    end
  end
end

ActiveRecord::Base.send(:include, LaserLemon::HasToken)
