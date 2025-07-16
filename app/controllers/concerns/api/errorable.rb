# frozen_string_literal: true

module Api
  module Errorable
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |error|
        render json: { error: error.message }, status: :internal_server_error
      end

      rescue_from ArgumentError do |error|
        render json: { error: error.message }, status: :bad_request
      end
    end
  end
end
