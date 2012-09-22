require 'rubygems'
require 'spork'

Spork.prefork do
  $:.unshift File.expand_path("../../lib", __FILE__)
  $:.unshift File.expand_path("../../", __FILE__)
  require 'bundler'
  Bundler.require

  require 'rspec'
  require 'timecop'
  # require 'fakefs'
  require 'factory_girl'
  require 'fileutils'
  require 'ap'
  
  require 'adept'
  
  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.mock_with :rspec
    config.before do
      Timecop.freeze
    end
    config.after do
      Timecop.return
    end
  end
end

Spork.each_run do
  require 'adept'
  Dir["spec/support/**/*.rb"].map{ |f| f.gsub(%r{.rb$}, '') }.each { |f| require f }
  Dir["spec/factories/**/*.rb"].map{ |f| f.gsub(%r{.rb$}, '') }.each { |f| require f }
  # This code will be run each time you run your specs.
end