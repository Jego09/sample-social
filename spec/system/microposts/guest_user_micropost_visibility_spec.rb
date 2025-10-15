require 'rails_helper'

RSpec.describe 'Guest user micropost visibility', type: :system do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user, content: 'Content') }

  it 'allows non-logged-in users to view microposts on user profile page' do
    visit user_path(user)

    within('.microposts') do
    #Instead of checking specific micropost ids, This line is more general and will work for any microposts in the DB.
    expect(page).to have_selector('[id^="micropost-"]') 
    # <- Check for the content of the micropost (Test data is defined in spec/support/test_data.rb)
    expect(page).to have_css("span.content", text: TEST_DATA[:micropost][:first_post]) 
    end
  end
end