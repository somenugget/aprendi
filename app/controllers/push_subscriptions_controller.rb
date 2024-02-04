class PushSubscriptionsController < ApplicationController
  def create
    subscription = find_subscription

    subscription.update!(push_subscription_params.merge(last_seen_at: Time.current))
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth, :user_agent)
  end

  def find_subscription
    current_user.push_subscriptions.find_by(
      endpoint: push_subscription_params[:endpoint],
      user_id: current_user.id
    ) || current_user.push_subscriptions.find_or_initialize_by(
      user_agent: push_subscription_params[:user_agent],
      user_id: current_user.id
    )
  end
end
