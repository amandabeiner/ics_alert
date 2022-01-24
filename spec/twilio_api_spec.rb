# frozen_string_literal: true

require './lib/twilio_api'

RSpec.describe TwilioApi do
  describe '#send_text_message' do
    from_phone_number = '+11234567890'
    to_phone_number = '+10987654321'
    alert_body = 'Alert!'

    before do
      ENV['FROM_PHONE_NUMBER'] = from_phone_number
      ENV['TO_PHONE_NUMBER'] = to_phone_number
      ENV['ALERT_BODY'] = alert_body
    end

    it 'creates a message with the correct arguments' do
      TwilioApi.send_text_message
      message = Twilio::REST::Client.messages.last

      expect(message[:from]).to eq(from_phone_number)
      expect(message[:to]).to eq(to_phone_number)
      expect(message[:body]).to eq(alert_body)
    end
  end
end
