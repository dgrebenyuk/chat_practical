require 'telegram/bot'

module Command
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      @user = user
      @message = message
      token = Rails.application.secrets.bot_token
      @api = ::Telegram::Bot::Api.new token
    end

    protected

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from][:id]
    end
  end

  class ToWeb < Base
    def send
      mes = Message.create! content: text, user_id: from

      # photo
      unless @message[:message][:photo].nil?
        ImageDownloadJob.perform_later get_image_link, mes.id
      end

      MessageBroadcastJob.perform_later mes
    end

    private

    def get_image_link
      # if possible, choosing photo resolution, smaller = 0
      if @message[:message][:photo].size >= 2
        resolution = 1
      else
        resolution = 0
      end
      response = @api.call('getFile', file_id: @message[:message][:photo][resolution][:file_id])
      # download link
      response['result']['file_path']
    end
  end

  class ToTg < Base
    def send_to_group(txt)
      send(txt, -194413633)
    end

    def send_to_user(txt)
      send(txt, @user.telegram_id)
    end

    private

    def send(text, chat_id)
      @api.call('sendMessage', chat_id: chat_id, text: text)
    end
  end
end
