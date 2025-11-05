# Take a look at app/services/favourite_service.rb in mastodon for an idea on
# how this might fit into an organizer in the future
class CreateFavorite
  include Interactor

  def call
    if Favorite.find_by(account: context.account, post: context.post)
      context.fail!(message: "Already Favorited")
    end
    context.favorite = Favorite.create(account: context.account,
                                        post: context.post)
  end
end
