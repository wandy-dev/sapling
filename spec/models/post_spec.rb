require 'rails_helper'

RSpec.describe Post do
  describe "callbacks" do
    let(:community) { create(:community) }
    let(:account) { create(:account) }

    before do
      allow(TimelineService).to receive(:append_post).and_return(nil)
      allow(TimelineService).to receive(:remove_post).and_return(nil)
    end

    describe "#append_to_timeline" do
      it "adds post to community timelines" do
        post = create(:post, account: account, communities: [community])

        expect(TimelineService).to have_received(:append_post).with(post)
      end
    end

    describe "#remove_from_timeline" do
      it "removes post from community timelines" do
        post = create(:post, account: account, communities: [community])

        post.destroy

        expect(TimelineService).to have_received(:remove_post).with(
          post, [community.id]
        )
      end
    end
  end
end
