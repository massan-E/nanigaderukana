require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  url = ENV['SELENIUM_DRIVER_URL']

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: url,
    options: options
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    if ENV['SELENIUM_DRIVER_URL']
      driven_by :remote_chrome
      Capybara.server_host = "web"
      Capybara.app_host = "http://web"
    else
      driven_by :selenium_chrome_headless
    end
  end
end
