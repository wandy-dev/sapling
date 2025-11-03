class HomeController < ApplicationController
  before_action :require_user_finished_onboarding

  def index
  end

  private
    def require_user_finished_onboarding
      return false unless user_signed_in?
      redirect_to new_account_path unless current_user.finished_onboarding?
    end
end
