require 'faraday'
require 'base64'

class ImageDownloadJob < ApplicationJob
  queue_as :default

  def perform(path, message_id)
    url = "https://api.telegram.org/file/bot#{Rails.application.secrets.bot_token}/#{path}"
    begin
      response = Faraday.get url.to_s
    rescue Faraday::Error::ConnectionFailed
      raise ArgumentError, 'bad url, connection failed'
    end
    status = response.status.to_i
    raise ArgumentError, "bad server response #{status}" if status >= 400
    save(response.body, message_id)
  end

  private

  def save(img, message_id)
    encoded = Base64.encode64 img
    Image.create! message_id: message_id, body: encoded
  end
end
