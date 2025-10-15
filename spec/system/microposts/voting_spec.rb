# spec/system/polls/voting_spec.rb
require 'rails_helper'

RSpec.describe 'Poll Voting', type: :system, js: true do
    let!(:admin_user) { create(:user, email: 'admin@example.com') }
    let!(:follower)   { create(:user, email: 'bob@example.com') }
    let!(:non_follower) { create(:user, email: 'alice@example.com') }
    let!(:poll_id) { 1 } # hardcoded poll id to 1 since the test DB is not resetting between tests
    let!(:poll_question) { "Which framework is the best?" }

  before do
    Capybara.reset_sessions! # Ensure a clean session for each test
    sign_in(follower)
    # Navigate to Polls
    visit polls_path
    expect(page).to have_content(poll_question)
    puts page.body.include?('Vote Now') ? "Polls page loaded" : "Polls missing"
  end

  it "allows follower to vote" do 
    # Click Vote Now dynamically
    find("a[href='/polls/#{poll_id}']", text: /Vote Now/, wait: 5).click
    
    sleep 2
    # Wait for options to appear, then click
    within('.poll-options', wait: 5) do

    click_button 'Ruby'

    end
    # Expect success flash
    expect(page).to have_selector('.alert.alert-success', text: 'Vote recorded successfully!')
  end
end

  it "prevents follower from voting twice" do

    # Click Vote Now dynamically
    find("a[href='/polls/#{poll_id}']", text: /Vote Now/i, wait: 5).click
    # Wait for options to appear, then click
    within('.poll-options', wait: 5) do

    click_button 'Ruby'

    end
    # Expect success flash
    expect(page).to have_selector('.alert.alert-success', text: 'Vote recorded successfully!')

    # Revisit the poll
    visit polls_path(poll)
    expect(page).to have_selector("span.label.label-success", text: "You voted", wait: 5)
  end


  ######################################################

  context "Non-follower actions" do
    before do
      sign_in(non_follower)
      visit polls_path
      expect(page).to have_content(poll_question)
    end

    it "allows non-follower to view poll" do
      expect(page).to have_content(poll_question)
    end

    it "prevents non-follower from voting" do
      expect(page).not_to have_button(/Vote Now/)
    end
  end
end
