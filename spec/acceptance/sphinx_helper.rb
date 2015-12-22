RSpec.configure do |config|
  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end
end
