require 'rails_helper'

RSpec.describe TimelineService do
  let(:user) { create(:user) }

  describe ".get_timeline" do
    let(:community) { create(:community) }
    let(:feed_instance) { instance_double(Feed) }

    after do
      TimelineService.get_timeline(community, user)
    end

    before do
      allow(user).to receive(
        :member_of?
      ).with(community.id).and_return(membership)
    end

    context "when user is a member of community" do
      let(:membership) { true }

      it "fetches from Feed with community private key" do
        expect(Feed).to receive(:new).with(
          "timeline:community:#{community.id}:public"
        ).and_return(feed_instance)

        expect(feed_instance).to receive(:fetch)
      end
    end

    context "when user is NOT a member of community" do
      let(:membership) { false }

      it "fetches from Feed with community public key" do
        expect(Feed).to receive(:new).with(
          "timeline:community:#{community.id}:private"
        ).and_return(feed_instance)

        expect(feed_instance).to receive(:fetch)
      end
    end
  end

  describe ".append_post" do
    let(:community) { create(:community) }

    before do
      Post.skip_callback(:commit, :after, :append_to_timeline)
      allow(Feed).to receive(:new).and_return(
        instance_double(Feed, append: nil, remove: nil)
      )
    end

    after do
      Post.set_callback(:commit, :after, :append_to_timeline)
    end

    it "appends to public and local timeline for each community" do
      post = create(:post, communities: [community])

      TimelineService.append_post(post)

      expect(Feed).to have_received(:new).with(
        "timeline:community:#{community.id}:public"
      )
      expect(Feed).to have_received(:new).with(
        "timeline:local"
      )
    end

    context "with community_only post" do
      let(:post) do
        create(:post, communities: [community], visibility: :community_only)
      end

      it "does not append to public timeline" do
        TimelineService.append_post(post)

        expect(Feed).not_to have_received(:new).with(
          "timeline:community:#{community.id}:public"
        )
      end
    end
  end

  describe ".remove_post" do
    let(:community) { create(:community) }

    before do
      Post.skip_callback(:commit, :after, :append_to_timeline)

      allow(Feed).to receive(:new).and_return(
        instance_double(Feed, append: nil, remove: nil)
      )
    end

    after do
      Post.set_callback(:commit, :after, :append_to_timeline)
    end

    # TODO: more cosideration needs to be put into how to handle a fan out
    # strategy
    it "removes from all timelines" do
      post = create(:post, communities: [community])

      TimelineService.remove_post(post)

      expect(Feed).to have_received(:new).with(
        "timeline:community:#{community.id}:private"
      )
      expect(Feed).to have_received(:new).with(
        "timeline:community:#{community.id}:public"
      )
      expect(Feed).to have_received(:new).with(
        "timeline:user:#{user.id}:local"
      )
    end
  end
end
