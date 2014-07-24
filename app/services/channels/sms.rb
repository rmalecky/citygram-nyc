module Citygram
  module Services
    module Channels
      class SMS < Base
        FROM_NUMBER = ENV.fetch('TWILIO_FROM_NUMBER')

        def self.client
          @client ||= Twilio::REST::Client.new(
            ENV.fetch('TWILIO_ACCOUNT_SID'),
            ENV.fetch('TWILIO_AUTH_TOKEN')
          )
        end

        def self.sms(*args)
          client.account.messages.create(*args)
        end

        def call
          self.class.sms(
            from: FROM_NUMBER,
            to: subscription.contact,
            body: event.title
          )
        rescue Twilio::REST::RequestError => e
          Citygram::App.logger.error(e)
          # TODO: deactivate subscription?
          raise NotificationFailure, e
        end
      end

      Channels[:sms] = Citygram::Services::Channels::SMS
    end
  end
end
