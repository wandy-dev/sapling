module Api
  module V1
    class CommunitiesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_cors_headers

      def index
        subdomain = params[:community_address]

        if subdomain.blank?
          render json: { error: "subdomain is required" }, status: :bad_request
          return
        end

        available = !Community.exists?(name: subdomain.downcase)

        render json: { subdomain: subdomain, available: available }
      end

      private

      def set_cors_headers
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "GET"
        headers["Access-Control-Allow-Headers"] = "Content-Type"
      end
    end
  end
end
