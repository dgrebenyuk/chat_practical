# Receives messages from Telegram
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # When user sends a message in Telegram, it goes to our
  # WebhooksController#callback in a params['webhook'] hash,
  # which contains the message and info about the user who sent it and etc.
  def callback
    dispatcher.new(webhook, user).process
    render nothing: true, head: :ok
  end

  private

  def webhook
    params['webhook']
  end

  def dispatcher
    BotMessageDispatcher
  end

  def from
    webhook[:message][:from]
  end

  def user
    @user ||= User.find_by(telegram_id: from[:id]) || register_user
  end

  def register_user
    @user = User.find_or_initialize_by(telegram_id: from[:id])
    @user.update_attributes!(username: "@#{from[:username]}")
    @user
  end
end
