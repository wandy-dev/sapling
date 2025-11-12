class ApplicationController < ActionController::Base
  before_action :require_user_finished_onboarding
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def require_user_finished_onboarding
      return false unless user_signed_in?
      redirect_to new_profile_path unless current_user.finished_onboarding?
    end
end
