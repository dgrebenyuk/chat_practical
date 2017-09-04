require 'telegram/bot'

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # any message should be sent in web
    ActionCable.server.broadcast 'room_channel', message: render_message(message)

    # message from web should be sent additionally to Telegram
    if message.user_id.nil?
      Command::Telegram.new(nil, nil).send_to_group(render_message(message,'tg_message'))
    end
  end

  private

  # rendering in /views
  def render_message(message, type = 'message')
    ApplicationController.renderer.render(partial: "messages/#{type}", locals: { message: message })
  end
end
