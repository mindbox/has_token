require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('has_token', '0.3.3') do |g|
  g.description = %(Generate unique tokens on your ActiveRecord models)
  g.url = 'http://github.com/laserlemon/has_token'
  g.author = 'Steve Richert'
  g.email = 'steve@laserlemon.com'
  g.ignore_pattern = %w(tmp/* script/*)
  g.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|t| load t }
