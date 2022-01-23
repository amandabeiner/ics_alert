# frozen_string_literal: true

require 'twilio-ruby'

# Public: communicate with the Twilio API
class TwilioApi
  def self.send_text_message
    new.send_text_message
  end

  def send_text_message
    twilio_client.messages.create(
      from: ENV['FROM_PHONE_NUMBER'],
      to: ENV['TO_PHONE_NUMBER'],
      body: ENV['ALERT_BODY']
    )
  end

  private

  def twilio_client
    Twilio::REST::Client.new(account_id, auth_token)
  end

  def account_id
    ENV['TWILIO_ACCOUNT_ID']
  end

  def auth_token
    ENV['TWILIO_AUTH_TOKEN']
  end
end
