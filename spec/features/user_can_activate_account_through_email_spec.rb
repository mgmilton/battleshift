require "rails_helper"

describe "As a non-activated user" do
  describe "after clicking activation link" do
    it "states status as  active" do
      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/activate"

      expect(page).to have_content("Thank you! Your account is now activated.")

      visit "/dashboard"

      expect(page).to have_content("Status: Active")
    end
  end
end
