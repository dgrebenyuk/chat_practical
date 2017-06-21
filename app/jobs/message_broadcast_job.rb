require 'telegram/bot'

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast 'room_channel', message: render_message(message)
    if message.user_id.nil?
      BotCommand::ToTg.new(nil, nil).send_to_group(render_message(message,'tg_message'))
      # BotCommand::ToTg.new.send_to_group(render_message(message, 'tg_message'))
    end
  end

  private

  def render_message(message, type = 'message')
    ApplicationController.renderer.render(partial: "messages/#{type}", locals: { message: message })
  end
end
