require "rails_helper"

RSpec.describe BuildPost, type: :unit do
  let(:account) { instance_double("Account") }
  let(:post) { instance_double("Post") }

  describe ".call" do
    context "with valid post params" do
      let(:post_params) { { body: "Hello world", visibility: "public" } }

      subject(:context) do
        described_class.call(
          account: account,
          post_params: post_params,
          attachments: nil
        )
      end

      before do
        allow(account).to receive(:posts).and_return(
          double("posts", build: post)
        )
        allow(post).to receive(:save).and_return(true)
      end

      it "builds a post" do
        expect(context.post).to eq(post)
        expect(post).to have_received(:save)
      end
    end
  end
end