require "rails_helper"

RSpec.describe CreateFavorite, type: :unit do
  let(:account) { instance_double("Account") }
  let(:post) { instance_double("Post") }
  let(:favorite_class) { double("Favorite") }
  let(:favorite) { instance_double("Favorite",
                                   "persisted?": true,
                                   post: post,
                                   account: account) }

  subject(:context) { described_class.call(account: account, post: post) }

  describe ".call" do
    context "when favorite has not already been created" do
      before do
        allow(Favorite).to(
          receive(:find_by).with(account: account,
                                 post: post).and_return(nil)
        )

        allow(Favorite).to(
          receive(:create).with(account: account,
                                post: post).and_return(favorite)
        )
      end

      it "is successful" do
        expect(context).to be_a_success
      end

      it "persists the favorite" do
        expect(context.favorite).to be_persisted
      end
    end

    context "when favorite has not already been created" do
      before do
        allow(Favorite).to(
          receive(:find_by).with(account: account,
                                 post: post).and_return(favorite)
        )
      end

      it "is not successful" do
        expect(context).to be_a_failure
      end

      it "distributes notifications" do
        expect(context.message).to be_present
      end
    end
  end
end
