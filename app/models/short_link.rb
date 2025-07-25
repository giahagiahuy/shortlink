class ShortLink < ApplicationRecord
  validates :original_url, presence: true
  validates :short_code, presence: true, uniqueness: true
end
