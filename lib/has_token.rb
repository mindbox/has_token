module LaserLemon
  module HasToken
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_token(*columns)
        options = columns.extract_options!
        options.reverse_merge!(
          :length => 6,
          :characters => [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).sum,
          :to_param => false
        )
        
        columns << :token if columns.empty?
        columns.collect!(&:to_sym)
        
        columns.each do |column|
          attr_readonly column
          
          default_value_for column do
            begin
              token_value = Array.new(options[:length]){ options[:characters].rand }.join
            end while exists?(column => token_value)
            token_value
          end
        end
        
        if options[:to_param]
          to_param_column = case
          when (options[:to_param] == true) && (columns.size == 1): columns.first
          when columns.include?(options[:to_param].to_sym): options[:to_param].to_sym
          end
          
          define_method :to_param do
            read_attribute(to_param_column)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, LaserLemon::HasToken)
