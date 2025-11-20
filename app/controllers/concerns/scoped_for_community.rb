module ScopedForCommunity
  extend ActiveSupport::Concern

  included do
    before_action :set_community!
    # helper_method :current_user

    private

    # def current_user
    #   @current_user ||= User.find_by(id: session[:user_id])
    # end

    def set_community!
      if community = Community.find_by(name: request.subdomain)
        Current.community = community
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
