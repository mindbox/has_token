# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_token}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steve Richert"]
  s.date = %q{2009-07-01}
  s.description = %q{Generate unique tokens on your ActiveRecord models}
  s.email = %q{steve@laserlemon.com}
  s.extra_rdoc_files = ["lib/has_token.rb", "lib/token.rb", "README.rdoc", "tasks/has_token_tasks.rake"]
  s.files = ["generators/has_token_migration/has_token_migration_generator.rb", "generators/has_token_migration/templates/migration.rb", "init.rb", "lib/has_token.rb", "lib/token.rb", "MIT-LICENSE", "Rakefile", "README.rdoc", "tasks/has_token_tasks.rake", "test/has_token_test.rb", "test/test_helper.rb", "VERSION.yml", "Manifest", "has_token.gemspec"]
  s.homepage = %q{http://github.com/laserlemon/has_token}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Has_token", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{has_token}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Generate unique tokens on your ActiveRecord models}
  s.test_files = ["test/has_token_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
