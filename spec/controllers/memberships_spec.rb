require 'rails_helper'

RSpec.describe "/communities/:community_id/memberships", type: :request do
  let(:admin) { create(:user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:public_community) { create(:community, :public) }
  let(:private_community) { create(:community, :private) }

  before do
    sign_in user
  end

  describe "POST /communities/:community_id/memberships" do
    context "for public community" do
      it "creates a membership for the user" do
        expect {
          post community_memberships_url(public_community)
        }.to change(Membership, :count).by(1)
      end

      it "redirects to the community page" do
        post community_memberships_url(public_community)
        expect(response).to redirect_to(community_url(public_community))
      end
    end

    context "for private community" do
      it "does not create a membership" do
        expect {
          post community_memberships_url(private_community)
        }.not_to change(Membership, :count)
      end

      it "redirects back with alert" do
        post community_memberships_url(private_community)
        expect(response).to redirect_to(community_url(private_community))
        expect(flash[:alert]).to be_present
      end
    end

    context "when already a member" do
      before do
        create(:membership, user: user, community: public_community)
      end

      it "does not create a duplicate membership" do
        expect {
          post community_memberships_url(public_community)
        }.not_to change(Membership, :count)
      end
    end
  end

  describe "GET /communities/:community_id/memberships" do
    context "as owner" do
      before do
        create(:membership, user: user, community: public_community,
               role: :owner)
      end

      it "returns http success" do
        get community_memberships_url(public_community)
        expect(response).to have_http_status(:success)
      end
    end

    context "as non-admin" do
      before do
        create(:membership, user: user, community: public_community,
               role: :member)
      end

      it "redirects with alert" do
        get community_memberships_url(public_community)
        expect(response).to redirect_to(community_url(public_community))
        expect(flash[:alert]).to be_present
      end
    end
  end
end
