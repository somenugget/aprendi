class PushNotification
  # Send push notification to user
  # @param subscription [PushSubscription]
  # @param title [String]
  # @param body [String]
  # @return [Boolean]
  def self.deliver(subscription:, title:, body:)
    response = WebPush.payload_send(
      message: JSON.generate({ title:, body: }),
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: vapid_details
    )

    response.code == '201'
  end

  # Vapid details for push notification
  # @return [Hash]
  def self.vapid_details
    {
      subject: "mailto:#{ENV['VAPID_EMAIL']}",
      public_key: ENV['VAPID_APPLICATION_SERVER_KEY'],
      private_key: ENV['VAPID_PRIVATE_KEY']
    }
  end
end
