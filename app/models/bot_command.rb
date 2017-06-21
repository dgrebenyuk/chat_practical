require 'telegram/bot'

module BotCommand
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      $logger ||= Logger.new(STDOUT)
      @user = user
      @message = message
      token = Rails.application.secrets.bot_token
      @api = ::Telegram::Bot::Api.new(token)
    end

    protected

    def send_to_tg(text, chat_id)
      $logger.debug "send_to_tg chat_id: #{chat_id}"
      $logger.debug "send_to_tg text: #{text}"
      @api.call('sendMessage', chat_id: chat_id, text: text)
    end

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from][:id]
    end
  end

  class ToWeb < Base
    def send_to_web
      mes = Message.create! content: text, user_id: from
      $logger.debug "send_to_web id: #{from}"
      $logger.debug "send_to_web text: #{text}"

      unless @message[:message][:photo].nil?
        $logger.debug @message[:message][:photo]
        response = @api.call('getFile', file_id: @message[:message][:photo][0][:file_id])
        $logger.debug response
        path = response['result']['file_path']
        $logger.debug path
        Image.download path, mes.id
      end

      MessageBroadcastJob.perform_later mes
    end
  end

  class ToTg < Base
    def send_to_group(txt)
      send_to_tg(txt, -194413633)
    end

    def send_to_user(txt)
      send_to_tg(txt, @user.telegram_id)
    end
  end
end
