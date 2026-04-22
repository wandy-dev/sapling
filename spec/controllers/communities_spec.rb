require 'rails_helper'

RSpec.describe "/communities", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /communities" do
    it "returns http success" do
      get communities_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /communities/new" do
    it "returns http success" do
      get new_community_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /communities" do
    context "with valid params" do
      it "creates a new community" do
        expect do
          post communities_url, params: {
            community: { name: "Test Community", visibility: "public" }
          }
        end.to change(Community, :count).by(1)
      end

      it "creates an owner membership for the creator" do
        post communities_url, params: {
          community: { name: "Test Community", visibility: "public" }
        }

        community = Community.last
        expect(community.memberships.find_by(user: user)).to be_owner
      end

      it "redirects to the community page" do
        post communities_url, params: {
          community: { name: "Test Community", visibility: "public" }
        }
        expect(response).to redirect_to(community_url(Community.last))
      end
    end

    context "with invalid params" do
      it "redirects back with error" do
        post communities_url, params: {
          community: { name: nil, visibility: "public" }
        }
        expect(response).to redirect_to(community_url(Community.last))
      end
    end
  end

  describe "GET /communities/:id" do
    let(:community) { create(:community) }

    it "returns http success" do
      get community_url(community)
      expect(response).to have_http_status(:success)
    end
  end
end
