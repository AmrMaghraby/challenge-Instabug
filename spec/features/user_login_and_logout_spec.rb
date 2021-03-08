require 'rails_helper'

feature "User logs in and logs out" do
  scenario "with correct details", js: true do
    create :user, username: 'someone',email: 'someone@example.tld', password: 'somepassword'
    visit "/users/sign_in"
    expect(current_path).to eq(new_user_session_path)
    login "someone@example.tld", "somepassword"
    expect(current_path).to eq "/"
    expect(page).to have_content "someone"
    click_link "someone"
    click_link "Logout"
    expect(current_path).to eq "/users/sign_in"
    expect(page).not_to have_content "someone@example.tld"
  end

  scenario "with wrong details", js: true do
    create :user, username: 'someone',email: 'someone@example.tld', password: 'somepassword'
    visit "/users/sign_in"
    expect(current_path).to eq(new_user_session_path)
    login "someone@example.tld", "password"
    expect(current_path).to eq "/users/sign_in"
  end


  private

  def login(email, password)
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end
end
