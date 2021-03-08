require 'rails_helper'
require 'spec_helper'
require 'rest_client'
require 'active_support/core_ext'

feature "User registers" do

  scenario "with valid details" , js: true do
    visit "/users/sign_up"
    expect(current_path).to eq(new_user_registration_path)
    sign_up("tester@example.tld", "tester", "123456", "123456")
    expect(current_path).to eq "/"
    expect(page).to have_content("tester")
  end

  context "with invalid details" do

    before do
      visit "/users/sign_up"
    end

    scenario "blank fields" do
      expect_fields_to_be_blank
      click_button "Sign up"
      expect(current_path).to eq "/users"
    end

    scenario "incorrect password confirmation" do
      sign_up("tester@example.tld", "tester", "123456", "123455")
      expect(current_path).to eq "/users"
    end

    scenario "already registered email", js:"true" do
      create(:user, email: "tester@example.tld")
      sign_up("tester@example.tld", "tester", "123456", "123456")
      expect(current_path).to eq "/users"
    end

    scenario "invalid email" do
      sign_up("invalid-email-for-testing", "tester", "123456", "123456")
      expect(current_path).to eq "/users"
    end

    scenario "too short password" do
      min_password_length = 6
      too_short_password = "p" * (min_password_length - 1)
      sign_up("someone@example.tld", "tester", too_short_password, too_short_password)
      expect(current_path).to eq "/users"
    end

  end

  private

  def expect_fields_to_be_blank
    expect(page).to have_field("Email", with: "", type: "email")
    expect(find_field("user_password", type: "password").value).to be_nil
    expect(find_field("Password confirmation", type: "password").value).to be_nil
  end
  
  def sign_up(email, username, password, password_confirm)
    fill_in "email", with: email
    fill_in "Username", with: username
    fill_in "user_password", with: password
    fill_in "Password confirmation", with: password_confirm
    click_button "Sign up"
  end

end
