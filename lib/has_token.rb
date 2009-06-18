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
          :characters => [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).sum
        )
        
        columns.each do |column|
          default_value_for column.to_sym do
            begin
              token_value = Array.new(options[:length]){ options[:characters].rand }.join
            end while exists?(column.to_sym => token_value)
            token_value
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, LaserLemon::HasToken)
