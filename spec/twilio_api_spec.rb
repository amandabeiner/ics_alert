# frozen_string_literal: true

require './lib/twilio_api'

RSpec.describe TwilioApi do
  describe '#send_text_message' do
    from_phone_number = '+11234567890'
    to_phone_number = '+10987654321'
    alert_body = 'Alert!'

    before do
      ENV['CALENDAR_ICS_1_FROM_PHONE_NUMBER'] = from_phone_number
      ENV['CALENDAR_ICS_1_TO_PHONE_NUMBER'] = to_phone_number
      ENV['CALENDAR_ICS_1_ALERT_BODY'] = alert_body
      ENV['CALENDAR_ICS_2_TO_PHONE_NUMBER'] = "#{from_phone_number},#{to_phone_number}"
    end

    it 'creates a message with the correct arguments' do
      TwilioApi.send_text_messages_for('CALENDAR_ICS_1')
      message = Twilio::REST::Client.messages.last

      expect(message[:from]).to eq(from_phone_number)
      expect(message[:to]).to eq(to_phone_number)
      expect(message[:body]).to eq(alert_body)
    end

    it 'creates a message for each comma-dilineated message' do
      TwilioApi.send_text_messages_for('CALENDAR_ICS_2')

      expect(Twilio::REST::Client.messages.length).to eq 2
    end
  end
end
