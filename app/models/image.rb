require 'faraday'
require 'base64'

class Image < ApplicationRecord
  def self.download(path, message_id)
    url = "https://api.telegram.org/file/bot#{Rails.application.secrets.bot_token}/#{path}"
    $logger.debug url
    begin
      res = Faraday.get url.to_s
    rescue Faraday::Error::ConnectionFailed
      raise ArgumentError, 'bad url, connection failed'
    end
    raise ArgumentError, "bad server response #{res.status.to_i}" if res.status.to_i >= 400  #res.success?
    $logger.debug res.body
    encoded = Base64.encode64 res.body
    $logger.debug encoded
    self.create! message_id: message_id, body: encoded
  end
end
