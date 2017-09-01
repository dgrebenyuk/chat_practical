# High level commands
class BotMessageDispatcher
  attr_reader :message, :user

  def initialize(webhook, user)
    @message = webhook
    @user = user
  end

  def process
    if chat_id > 0
      Command::Telegram.new(@user, @message).send_to_user('Hello! You should '\
      'invite me to group, so I could read user messages and write messages '\
      'sending by people outside Telegram. Speaking with me has no sence for now')
    else
      Command::Site.new(@user, @message).send
    end
  end

  private

  def chat_id
    @message[:message][:chat][:id]
  end
end
