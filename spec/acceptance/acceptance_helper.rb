require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  include ActionView::RecordIdentifier

  config.use_transactional_fixtures = false

  Capybara.javascript_driver = :poltergeist

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
