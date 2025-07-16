# spec/services/url_shortener_service_spec.rb
require 'rails_helper'

RSpec.describe UrlShortenerService, type: :service do
  describe ".encode" do
    context "with a valid original_url" do
      let(:original_url) { "https://example.com" }

      it "creates or finds a ShortLink with correct URL" do
        short_link = described_class.encode(original_url)

        expect(short_link).to be_a(ShortLink)
        expect(short_link.original_url).to eq(original_url)
        expect(short_link.short_code).to be_present
        expect(short_link.short_code.length).to eq(6)
      end

      it "returns the same ShortLink if it already exists" do
        existing = create(:short_link, original_url: original_url)
        expect(described_class.encode(original_url)).to eq(existing)
      end
    end

    context "with blank original_url" do
      it "raises ArgumentError" do
        expect {
          described_class.encode("")
        }.to raise_error(ArgumentError, "Original url can't be blank")
      end
    end

    context "uniqueness and retry logic" do
      let(:original_url) { "https://example.com/unique" }
      it "retries until it finds a unique short_code" do
        allow(SecureRandom).to receive(:alphanumeric).and_return("code_1", "code_2")

        create(:short_link, short_code: "code_1")

        short_link = described_class.encode(original_url)
        expect(short_link.short_code).to eq("code_2")
      end

      it "raises an error after MAX_ATTEMPTS failures" do
        allow(SecureRandom).to receive(:alphanumeric).and_return("code_1")

        create(:short_link, short_code: "code_1")

        expect {
          described_class.encode(original_url)
        }.to raise_error(StandardError)
      end
    end
  end

  describe ".decode" do
    let(:short_link) { create(:short_link, original_url: "https://example.com", short_code: "abc123") }

    it "returns the ShortLink from the short_url" do
      result = described_class.decode("http://localhost:3000/#{short_link.short_code}")
      expect(result).to eq(short_link)
    end

    it "returns nil for invalid short_code" do
      result = described_class.decode("http://invalid.com/123")
      expect(result).to be_nil
    end
  end
end
