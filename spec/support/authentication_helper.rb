module AuthenticationHelper
  def sign_in(user, password: 'password') # Changed the password from 'password123' to 'password' to match the data from seeds.rb and factories
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log in'
    expect(page).to have_content('Log out') # Verify login was successful, helps also on slow test environments.
  end

  def sign_out
    click_link 'Log out'
  end
end

RSpec.configure do |config|
  config.append_before(:each, type: :system) do |example|
    if example.metadata[:signed_in]
      user_to_sign_in = respond_to?(:admin_user) ? admin_user : current_user
      sign_in(user_to_sign_in)
    end
  end
end