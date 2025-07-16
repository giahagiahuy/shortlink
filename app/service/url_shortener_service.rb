class UrlShortenerService
  SHORT_CODE_LENGTH = 6
  MAX_ATTEMPTS = 5

  def self.encode(original_url)
    raise ArgumentError, "Original url can't be blank" if original_url.blank?

    ShortLink.find_or_create_by(original_url: original_url) do |link|
      link.short_code = generate_unique_code
    end
  end

  def self.decode(input)
    code = input.to_s.split('/').last
    return nil if code.blank?

    ShortLink.find_by(short_code: code)
  end

  private

  def self.generate_unique_code
    MAX_ATTEMPTS.times do
      code = SecureRandom.alphanumeric(SHORT_CODE_LENGTH)

      return code unless ShortLink.exists?(short_code: code)
    end

    raise StandardError, "Failed to generate a unique short code after #{MAX_ATTEMPTS} attempts"
  end
end
