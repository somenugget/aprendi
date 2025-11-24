require 'telegram/bot'

class TelegramWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def redirect
    redirect_to 'tg://resolve?domain=AprendiAppBot&start=dashboard', allow_other_host: true
  end

  def create
    bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
    update = Telegram::Bot::Types::Update.new(update_params)

    # TG::Bot.call(bot:, update:)

    TG::Dispatcher.call(bot:, update:)

    head :ok
  rescue StandardError => e
    Rails.error.report(e)
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    head :ok # Always return 200 to Telegram to avoid retries
  end

  private

  def update_params
    # Telegram sends JSON in the request body
    # Rails automatically parses JSON, but we'll use the raw params hash
    params.to_unsafe_h.with_indifferent_access
  end
end
