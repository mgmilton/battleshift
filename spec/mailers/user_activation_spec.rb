require "rails_helper"

RSpec.describe UserActivationMailer, type: :mailer do
  let(:user) { create :user }
  let(:mail) { described_class.activation_email(user).deliver_now }

  it "renders the subject line" do
    expect(mail.subject).to eq("Welcome to Battleshift")
  end

  it "renders the reciever email" do
    expect(mail.to).to eq([user.email])
  end

  it "renders the sender email" do
    expect(mail.from).to eq(["boss@battleshift.com"])
  end

  it "displays user login credentials" do
    expect(mail.body.encoded).to match(user.name)
    expect(mail.body.encoded).to match(user.email)
    expect(mail.body.encoded).to match(user.api_key)
  end

  it "displays activation link" do
    expect(mail.body.encoded).to match("/activate")
  end
end
