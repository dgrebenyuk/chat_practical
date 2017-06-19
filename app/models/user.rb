class User < ApplicationRecord
  has_many :messages
  validates_uniqueness_of :telegram_id
end
