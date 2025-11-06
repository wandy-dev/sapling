class FavoritesController < ApplicationController
  before_action :set_account, :set_post

  def create
    CreateFavorite.call(account: @account, post: @post)
  end

  private
    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_post
      @post = Post.find(params[:post_id])
    end
end
