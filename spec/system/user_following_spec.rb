require 'rails_helper'

RSpec.describe 'User Following', type: :system, signed_in: true do
  let!(:other_user) { create(:user) }
  let!(:current_user) { create(:user, :admin, email: 'admin@example.com') }

  it 'allows user to follow another user from their profile page' do
    #removed Sleep to make the test faster, also its unnecessary. 
    visit users_path 

    within('ul.users') do
      first('li a').click
    end

    within('.users') do
      click_link 'Alice TestUser' # Click on the user to view their profile
    end

    # Check initial followers count
    expect(find('#followers.stat')).to have_text('0')

    within('#follow_form') do
      click_button 'Follow'
    end

    # Check that followers count increased
    expect(find('#followers.stat')).to have_text('1')
  end
end