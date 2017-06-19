require 'telegram/bot'

module BotCommand
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      $logger ||= Logger.new(STDOUT)
      @user = user
      @message = message
      token = Rails.application.secrets.bot_token
      @api = MyApi.new(token)
    end

    def should_start?
      raise NotImplementedError
    end

    def start
      raise NotImplementedError
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

  class Start < Base
    def should_start?
      text =~ /\A\/start/
    end

    def start
      send_to_tg_user 'Hello! You should invite me to group, so I could read user
      messages and write messages sending by people outside Telegram. Speaking
      with me has no sence for now'
    end
  end

  class ForwardingToWeb < Base
    def send_to_web
      Message.create! content: text, user_id: from
      $logger.debug "send_to_web id: #{from}"
      $logger.debug "send_to_web text: #{text}"
    end
  end

  class ForwardingToTg < Base
    def send_to_group(txt)
      send_to_tg(txt, -194413633)
    end

    def send_to_user(txt)
      send_to_tg(txt, @user.telegram_id)
    end
  end

  class MyApi < ::Telegram::Bot::Api
    def call(endpoint, raw_params = {})
      params = build_params(raw_params)
      # $logger.debug "params: #{endpoint}"
      response = conn.post("/bot#{token}/#{endpoint}", params)
      if response.status == 200
        JSON.parse(response.body)
      else
        raise Exceptions::ResponseError.new(response),
        'Telegram API has returned the error.'
      end
    end
  end
end
