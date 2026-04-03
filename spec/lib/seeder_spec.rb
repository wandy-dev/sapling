require 'rails_helper'

RSpec.describe Seeder do
  describe ".create_community" do
    context "with name only" do
      it "creates a community" do
        expect {
          Seeder.create_community(name: "test_community")
        }.to change(Community, :count).by(1)

        expect(Community.last.name).to eq("test_community")
        expect(Community.last.custom_domain).to be_nil
      end
    end

    context "with custom domain" do
      it "creates a community with custom domain" do
        Seeder.create_community(name: "test", custom_domain: "custom.com")

        community = Community.find_by(name: "test")
        expect(community.custom_domain).to eq("custom.com")
      end
    end
  end

  describe ".create_user" do
    let(:community) { create(:community, name: "community_a") }

    context "with explicit community" do
      it "creates user in the specified community" do
        user = Seeder.create_user(
          email: "test@example.com",
          password: "password",
          community: community
        )

        expect(user.email).to eq("test@example.com")
        expect(user.community).to eq(community)
      end
    end

    context "without community" do
      it "uses existing community if one exists" do
        existing_community = create(:community, name: "existing")

        user = Seeder.create_user(
          email: "test@example.com",
          password: "password"
        )

        expect(user.community).to eq(existing_community)
      end

      it "creates new community if none exists" do
        Community.delete_all

        user = Seeder.create_user(
          email: "test@example.com",
          password: "password"
        )

        expect(user.community.name).to eq("main")
      end
    end
  end
end
