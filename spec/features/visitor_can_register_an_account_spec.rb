require "rails_helper"

describe "As a guest visitor" do
  describe "when I visit the root and click register" do
    it "presents a form for registration" do
      visit "/"

      click_link "Register"
      expect(current_path).to eq("/register")

      fill_in "/register[email]", with: "user@yahoo.com"
      fill_in "/register[name]", with: "Tom Hanks"
      fill_in "/register[password]", with: "password"
      fill_in "/register[password_confirmation]", with: "password"
      click_on "Register Account"

      expect(current_path).to eq("/dashboard")
      expect(page).to have_content("Logged in as Tom Hanks")
      expect(page).to have_content("This account has not yet been activated. Please check your email.")
    end


    it "requires a unique email" do
      visit "/"

      click_link "Register"
      expect(current_path).to eq("/register")

      fill_in "/register[email]", with: "user@yahoo.com"
      fill_in "/register[name]", with: "Tom Hanks"
      fill_in "/register[password]", with: "password"
      fill_in "/register[password_confirmation]", with: "password"
      click_on "Register Account"
      click_on "Log Out"

      visit "/"

      click_link "Register"
      expect(current_path).to eq("/register")

      fill_in "/register[email]", with: "user@yahoo.com"
      fill_in "/register[name]", with: "Tom Hanks"
      fill_in "/register[password]", with: "password"
      fill_in "/register[password_confirmation]", with: "password"
      click_on "Register Account"

      expect(current_path).to eq("/register")
    end
  end
end
