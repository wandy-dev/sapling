require 'rails_helper'

RSpec.describe "Controller Concerns", type: :controller do
  describe "CommunityResolver" do
    let!(:community_a) { create(:community, name: "community_a", custom_domain: "custom.com") }

    controller do
      def index
        render json: { community_id: Current.community&.id }
      end
    end

    context "with custom domain" do
      it "sets Current.community to the matching community" do
        request.host = "custom.com"
        get :index
        response_body = JSON.parse(response.body)
        expect(response_body['community_id']).to eq(community_a.id)
      end
    end

    context "with subdomain" do
      it "sets Current.community from subdomain" do
        request.host = "community_a.example.com"
        get :index
        response_body = JSON.parse(response.body)
        expect(response_body['community_id']).to eq(community_a.id)
      end
    end

    context "with unknown host" do
      it "sets Current.community to nil" do
        request.host = "unknown.com"
        get :index
        expect(Current.community).to be_nil
      end
    end
  end
end
