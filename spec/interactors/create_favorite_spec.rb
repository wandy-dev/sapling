RSpec.describe CreateFavorite, type: :unit do
  let(:account) { FactoryBot.create(:account) }
  let(:status) { FactoryBot.create(:status) }

  subject(:context) { CreateFavorite.call(account: account, status: status) }

  describe ".call" do
    context "valid credentials" do
      it "is successful" do
        expect(context).to be_a_success
      end

      it "persists the favorite" do
        expect(context.favorite).to be_persisted
      end
    end

    context "invalid credentials" do
      xit "is not successful" do
        expect(context).to be_a_failure
      end

      xit "distributes notifications" do
        expect(context.message).to be_present
      end
    end
  end
end
