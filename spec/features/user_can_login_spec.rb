require "rails_helper"

describe "As a registered user" do
  describe "when I visit the root and click login" do
    it "logs me in and send to dashboard" do
      user = create(:inactive_user)
      visit "/"

      click_link "Login"
      expect(current_path).to eq("/login")

      fill_in "email", with: user.email
      fill_in "password", with: user.password
      click_on "Log In"

      expect(current_path).to eq("/dashboard")
      expect(page).to have_content("Logged in as Hal Incandenza")
      expect(page).to have_content("This account has not yet been activated. Please check your email.")

      click_on "Log Out"

      expect(current_path).to eq("/")
    end


    it "renders a new session with incorrect info" do
      user = create(:inactive_user)
      visit "/"

      click_link "Login"
      expect(current_path).to eq("/login")

      fill_in "email", with: "fake email"
      fill_in "password", with: user.password
      click_on "Log In"

      expect(current_path).to eq("/login")
    end
  end
end
