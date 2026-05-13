class ApplicationController < ActionController::Base
  include CommunityResolver
  before_action :set_current_account!
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def set_current_account!
      Current.account = session[:current_account] || current_user&.account
    end
    def require_user_finished_onboarding
      redirect_to new_account_path if Current.account.nil?
    end

    def go_landing!
      unless user_signed_in?
        redirect_to root_path, status: 302
      end
    end
end
