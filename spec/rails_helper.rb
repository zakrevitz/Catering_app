# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'devise'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true. 

  # Before each test Active Record will issue a begin
  # transaction statement and issue a rollback after the test is executed
  config.use_transactional_fixtures = true

  # If any part of your code is using threads to access the database and you need
  # to test it, you can just set ActiveRecord::Base.shared_connection = nil
  # during that specific test and everything should work.

  # Below needs only for Capybara tests ORLY?

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    FakeWeb.allow_net_connect = false
  end

  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
  
  config.include APIMatchers::RSpecMatchers
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.infer_spec_type_from_file_location!
end
