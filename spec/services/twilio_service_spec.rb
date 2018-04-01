require "spec_helper"
require './app/services/twilio_service.rb'
require './spec/support/twilio_fake.rb'

describe TwilioService do
  describe "test it sends message" do
    it "sends message" do
      tw = TwilioFake.new
      tw.text!('Hello', '123123123')

      expect(tw.client.messages.last.to).to eq('123123123')
      expect(tw.client.messages.last.from).to eq('Fake Number')
      expect(tw.client.messages.last.body).to eq('Hello')
    end
  end
end
