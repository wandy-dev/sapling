require 'rails_helper'

RSpec.describe Membership do
  describe "validations" do
    it "prevents duplicate memberships for same user and community" do
      community = create(:community)
      user = create(:user)

      create(:membership, user: user, community: community)
      expect {
        create(:membership, user: user, community: community)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "roles" do
    it "defaults to member" do
      membership = build(:membership)
      expect(membership).to be_member
    end

    it "can be set as admin" do
      membership = build(:membership, :admin)
      expect(membership).to be_admin
    end

    it "can be set as owner" do
      membership = build(:membership, :owner)
      expect(membership).to be_owner
    end
  end
end
