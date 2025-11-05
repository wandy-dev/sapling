# Take a look at app/services/favourite_service.rb in mastodon for an idea on
# how this might fit into an organizer in the future
class CreateFavorite
  include Interactor
  delegate :favorite, :account, :status, to: :context

  def call
    if favourite = Favourite.find_by(account: account, status: status)
      context.fail!(message: "Already Favorited")
    end
    context.fail! unless favourite = Favourite.create(account: account,
                                                      status: status)
  end
end

