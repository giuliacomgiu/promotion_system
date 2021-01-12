# Devise support. For more info: https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
# https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-%28and-RSpec%29
RSpec.configure do |config|
  config.include Warden::Test::Helpers
end
