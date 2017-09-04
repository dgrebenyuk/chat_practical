require 'test_helper'

class MessageBroadcastJobTest < ActiveJob::TestCase

  queue_as :default

  def perform(message)
    ActionCable.server.broadcast 'room_channel', message: render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end

  # test "the truth" do
  #   assert true
  # end
end
