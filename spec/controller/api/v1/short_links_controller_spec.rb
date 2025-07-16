require 'rails_helper'

RSpec.describe Api::V1::ShortLinksController, type: :controller do
  let(:base_url) { "http://test.host" }

  describe 'POST #encode' do
    let(:original_url) { "https://example.com/page?param=value" }

    def do_request(params = {})
      post :encode, params: params
    end

    context 'with valid URL' do
      it 'returns a short_url' do
        do_request(original_url: original_url)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["short_url"]).to be_present
        expect(json["short_url"]).to match(%r{#{base_url}/\w{6}})
      end
    end

    context 'with blank URL' do
      it 'returns a 400 error' do
        do_request(original_url: "")

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Original url can't be blank")
      end
    end
  end

  describe 'POST #decode' do
    def do_request(params = {})
      post :decode, params: params
    end

    context 'when short link exists' do
      let(:original_url) { "https://example.com/something" }
      let!(:short_link) { create(:short_link, original_url: original_url, short_code: "AbCdEf") }

      it 'returns the original_url' do
        do_request(short_url: "#{base_url}/#{short_link.short_code}")

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["original_url"]).to eq(original_url)
      end
    end

    context 'when short link does not exist' do
      it 'returns a 404 error' do
        do_request(short_url: "#{base_url}/NotReal")

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("URL not found")
      end
    end
  end
end
