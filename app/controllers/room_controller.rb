class RoomController < ApplicationController
  def show
    @messages = Message.all
  end
end
