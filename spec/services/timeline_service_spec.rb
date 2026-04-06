require 'rails_helper'

RSpec.describe TimelineService do
  describe ".get_community_timeline" do
    let(:community) { create(:community) }
    let(:user) { create(:user) }

    it "fetches from Feed with community public key when user is member" do
      allow(user).to receive(:member_of?).with(community.id).and_return(true)
      feed_instance = instance_double(Feed)
      expect(Feed).to receive(:new).with("timeline:community:#{community.id}:private").and_return(feed_instance)
      expect(feed_instance).to receive(:fetch)

      TimelineService.get_community_timeline(community, user)
    end

    it "fetches from Feed with community private key when user is not member" do
      allow(user).to receive(:member_of?).with(community.id).and_return(false)
      feed_instance = instance_double(Feed)
      expect(Feed).to receive(:new).with("timeline:community:#{community.id}:public").and_return(feed_instance)
      expect(feed_instance).to receive(:fetch)

      TimelineService.get_community_timeline(community, user)
    end
  end

  describe ".append_post" do
    let(:community) { create(:community) }

    before do
      Post.skip_callback(:commit, :after, :append_to_timeline)
      allow(Feed).to receive(:new).and_return(instance_double(Feed, append: nil, remove: nil))
    end

    after do
      Post.set_callback(:commit, :after, :append_to_timeline)
    end

    it "appends to public and local timeline for each community" do
      post = create(:post, communities: [community])

      TimelineService.append_post(post)

      expect(Feed).to have_received(:new).with("timeline:community:#{community.id}:public")
      expect(Feed).to have_received(:new).with("timeline:local")
    end

    context "with community_only post" do
      let(:post) { create(:post, communities: [community], visibility: :community_only) }

      it "does not append to public timeline" do
        TimelineService.append_post(post)

        expect(Feed).not_to have_received(:new).with("timeline:community:#{community.id}:public")
      end
    end
  end

  describe ".remove_post" do
    let(:community) { create(:community) }

    before do
      Post.skip_callback(:commit, :after, :append_to_timeline)
      allow(Feed).to receive(:new).and_return(instance_double(Feed, append: nil, remove: nil))
    end

    after do
      Post.set_callback(:commit, :after, :append_to_timeline)
    end

    it "removes from all timelines" do
      post = create(:post, communities: [community])

      TimelineService.remove_post(post)

      expect(Feed).to have_received(:new).with("timeline:community:#{community.id}:private")
      expect(Feed).to have_received(:new).with("timeline:community:#{community.id}:public")
      expect(Feed).to have_received(:new).with("timeline:local")
    end
  end
end
