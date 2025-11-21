class LandingController < ApplicationController
  before_action :go_home
  def index
  end

  private

  def go_home
    if user_signed_in?
      redirect_to posts_path, status: 302
    end
  end
end
