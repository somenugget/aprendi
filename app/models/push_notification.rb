class PushNotification
  # Send push notification to user
  def self.send(subscription:, title:, body:)
    WebPush.payload_send(
      message: JSON.generate({ title:, body: }),
      endpoint: subscription.endpoint,
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: vapid_details
    )
  end

  # Vapid details for push notification
  def self.vapid_details
    {
      subject: "mailto:#{ENV['VAPID_EMAIL']}",
      public_key: ENV['VAPID_APPLICATION_SERVER_KEY'],
      private_key: ENV['VAPID_PRIVATE_KEY']
    }
  end
end
