require 'rails_helper'

RSpec.describe Community do
  describe "visibility" do
    it "defaults to public" do
      community = create(:community)
      expect(community).to be_visibility_public
    end

    it "can be set to private" do
      community = create(:community, :private)
      expect(community).to be_visibility_private
    end
  end

  describe "scope: publicly_visible" do
    it "only returns public communities" do
      public_community = create(:community, :public)
      private_community = create(:community, :private)

      expect(Community.visibility_public).to include(public_community)
      expect(Community.visibility_public).not_to include(private_community)
    end
  end
end
