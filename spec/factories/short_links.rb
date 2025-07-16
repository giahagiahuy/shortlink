# spec/factories/short_links.rb
FactoryBot.define do
  factory :short_link do
    original_url { "https://example.com" }
    short_code { SecureRandom.alphanumeric(6) }
  end
end
