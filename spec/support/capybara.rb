require 'capybara/rspec'
require 'selenium-webdriver'

# CI環境かどうかを判断
is_ci = ENV['CI'] == 'true'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  if is_ci
    # CI環境ではローカルのChromeを使用
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      capabilities: options
    )
  else
    # ローカル開発環境ではDockerのSeleniumを使用
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://chrome:4444/wd/hub",
      capabilities: options
    )
  end
end

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.server_port = 3001
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    
    if is_ci
      # CI環境の設定
      Capybara.server_host = '127.0.0.1'
      Capybara.app_host = "http://127.0.0.1:#{Capybara.server_port}"
    else
      # Docker環境の設定
      Capybara.server_host = 'web'
      Capybara.app_host = 'http://web'
    end
  end
end