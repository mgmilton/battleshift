class TwilioFake

  attr_reader :client

  def initialize
    @client = TwilioMock::Mocker.new
  end

  def text!(msg, number)
    attrs = {
      from: 'Fake Number',
      to: number,
      body: msg,
    }
    @client.create_message(attrs)
  end

end
