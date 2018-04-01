class TwilioService

  def self.client
    Twilio::REST::Client.new
  end

  def self.text!(msg, number)
    if number
      client.messages.create({
        from: Rails.application.secrets.twilio_phone_number,
        to: "#{number}",
        body: "#{msg}"
      })
    end
  end

end
