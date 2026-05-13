require 'rails_helper'

RSpec.describe Membership do
  describe "validations" do
    it "prevents duplicate memberships for same account and community" do
      community = create(:community)
      account = create(:account)

      create(:membership, account: account, community: community)
      expect {
        create(:membership, account: account, community: community)
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
