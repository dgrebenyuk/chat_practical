require 'telegram/bot'

module BotCommand
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      @user = user
      @message = message
      token = Rails.application.secrets.bot_token
      @api = ::Telegram::Bot::Api.new(token)
    end

    def should_start?
      raise NotImplementedError
    end

    def start
      raise NotImplementedError
    end

    protected

    def send_message(text, options={})
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text)
    end

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from]
    end
  end

  class Start < Base
    def should_start?
      text =~ /\A\/start/
    end

    def start
      send_message('Hello! You should invite me to group, so I could read user
      messages and write messages sending by people outside Telegram. Speaking
      with me has no sence for now')
    end
  end

  class Undefined < Base
    def send_to_web
      mes = Message.create! content: text
      $logger.debug "bot_command send_to_web mes: #{text}"
    end
  end
end
