class ApplicationController < ActionController::Base
  before_action :require_user_finished_onboarding
  before_action :set_admin
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def require_user_finished_onboarding
    end

    def set_admin
      @administrator = Account.first
    end

    def go_landing!
      unless user_signed_in?
        redirect_to root_path, status: 302
      end
    end
end
