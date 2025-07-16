module Api
  module V1
    class ShortLinksController < ActionController::API
      include Api::Errorable

      def encode
        link = UrlShortenerService.encode(encode_params[:original_url])
        render json: { short_url: short_url_for(link) }
      end

      def decode
        link = UrlShortenerService.decode(decode_params[:short_url])

        if link
          render json: { original_url: link.original_url }
        else
          render json: { error: "URL not found" }, status: :not_found
        end
      end

      private

      def short_url_for(link)
        "#{request.base_url}/#{link.short_code}"
      end

      def encode_params
        params.permit(:original_url)
      end

      def decode_params
        params.permit(:short_url)
      end
    end
  end
end
