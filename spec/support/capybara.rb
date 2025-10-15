require "capybara/rspec"

Capybara.run_server = false # Running the server with Puma in a separate process to avoid TCP Timeout errors (AI INFORMATION)
Capybara.ignore_hidden_elements = false
Capybara.default_max_wait_time = 10
Capybara.server = :puma, {Silent: true}
Capybara.always_include_port = true
Capybara.server_host = '127.0.0.1'
Capybara.server_port = 3001  # fixed port (AI INFORMATION to avoid TCP Timeout errors)
Capybara.app_host = "http://127.0.0.1:3001" # match the server port (AI INFORMATION to avoid TCP Timeout errors)

# Configure Chrome options for Selenium
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1920,1080")
  options.add_argument('--headless=new') unless ENV["SHOW_BROWSER"].present?
  options.add_preference('download.default_directory', Rails.root.join('tmp/downloads').to_s)
  options.add_preference('download.prompt_for_download', false)
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome

# System tests automatically use javascript_driver
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome
  end
  
  # Reset sessions between tests to avoid state leakage
  config.after(:each, type: :system) do
    Capybara.reset_sessions!
    sleep 1
  end
end