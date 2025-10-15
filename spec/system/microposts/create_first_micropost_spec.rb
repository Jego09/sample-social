require 'rails_helper'

#Delete all microposts of the current user first before this test to ensure a clean state

# Changed the name From Deleting microposts to Creating first micropost
RSpec.describe 'Creating first micropost', type: :system, signed_in: true do 

  # changed to a fixed email to match the seeded admin user
  let!(:admin_user) { create(:user, email: 'admin@example.com') } 

  it 'allows user to create their first micropost' do

    # Repositioned to check for microposts first before posting
    expect(page).not_to have_selector('.microposts li') 
  
    within('#navbar-menu') do
      click_link 'Home'
    end

    fill_in 'Compose new micropost...', with: TEST_DATA[:micropost][:first_post]
    click_button 'Post'

    within('#navbar-menu') do
      # Navigate to account settings
      click_link 'Account' 
    end 

    within('#dropdown-menu') do
      # Navigate to profile to see the new micropost
      click_link 'Profile' 
    end 

    within('.microposts') do
      expect(page).to have_selector('li', count: 1) # Check that there is exactly one micropost 
      expect(page).to have_content(TEST_DATA[:micropost][:first_post])
    end
  end
end