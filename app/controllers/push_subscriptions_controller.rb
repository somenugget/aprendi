class PushSubscriptionsController < ApplicationController
  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(
      user_agent: push_subscription_params[:user_agent]
    )

    subscription.update!(push_subscription_params.merge(last_seen_at: Time.current))
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth, :user_agent)
  end
end
