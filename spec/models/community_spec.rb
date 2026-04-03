require 'rails_helper'

RSpec.describe Community, type: :model do
  describe "#all_hosts" do
    let!(:community_a) { create(:community, name: "community_a", custom_domain: "custom.com") }
    let!(:community_b) { create(:community, name: "community_b") }

    it "includes custom domains" do
      expect(Community.all_hosts).to include("custom.com")
    end

    it "generates subdomain variants" do
      expect(Community.all_hosts).to include("community_a.example.com")
      expect(Community.all_hosts).to include("community_b.example.com")
    end

    it "includes main domain" do
      expect(Community.all_hosts).to include("example.com")
    end

    context "with no communities" do
      before do
        Community.destroy_all
      end

      it "returns main domain only when no communities exist" do
        expect(Community.all_hosts).to eq(["example.com"])
      end
    end
  end
end
