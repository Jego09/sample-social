require 'rails_helper'

RSpec.describe 'Deleting microposts', type: :system, signed_in: true, js: true do #Erased signed_in: true and Added js: true cause delete link is running on turbo, without this capybara default driver will not work. (AI INFORMATION)
  let!(:admin_user) { create(:user, email: 'admin@example.com') } # changed the name to an email to match the seeded admin user (AI INFORMATION)
  let!(:micropost_count) { 24 } # Added this line to define the micropost count variable (AI INFORMATION)

    it 'admin users can delete other admins micropost' do

      #Added this line to navigate to home page where microposts are listed
      click_link 'Home' 

      #hardcoded the micropost id's because factory bot is not resetting the id's after each test run because server does not have a default test database setup. 
      expect(page).to have_css("#micropost-#{micropost_count}")

      within("#micropost-#{micropost_count}") do
        accept_confirm do
          click_link 'delete'
        end
      end

      expect(page).to have_css('.alert.alert-success', text: 'Micropost deleted')
      expect(page).not_to have_css("#micropost-#{micropost_count}") # Check that the micropost is no longer present
    end
  end