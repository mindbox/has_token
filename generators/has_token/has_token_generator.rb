class HasTokenGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', File.join('db', 'migrate'), :migration_file_name => 'create_tokens'

      m.directory File.join('config', 'initializers')
      m.template 'initializer.rb', File.join('config', 'initializers', 'has_token.rb')
    end
  end
end
