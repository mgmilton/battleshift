require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:password)}
    it {should validate_confirmation_of(:password)}
  end

  describe "status" do
    it "he or she is created as an uniactivated user" do
      user = create(:user)

      expect(user.status).to eq("inactivated")
      expect(user.inactivated?).to be_truthy
    end
  end

  describe "instance methods" do
    subject {create :user}
    describe "#send_activation" do
      it "sends an activation email" do
        expect { subject.send_activation }.to change { ActionMailer::Base.deliveries.count }.by(1)

      end
    end
  end
end
