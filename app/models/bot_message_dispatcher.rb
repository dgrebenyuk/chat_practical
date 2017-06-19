# Command trees
class BotMessageDispatcher
  attr_reader :message, :user

  def initialize(webhook, user)
    @message = webhook
    @user = user
  end

  def process
    start_command = BotCommand::Start.new(user, message)

    if start_command.should_start?
      start_command.start
    else
      unknown_command
    end
  end

  private

  def unknown_command
    BotCommand::ForwardingToWeb.new(user, message).send_to_web
  end
end
