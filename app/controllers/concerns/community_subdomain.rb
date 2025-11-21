module CommunitySubdomain
  extend ActiveSupport::Concern

  included do
    before_action :set_community!

    private

    def set_community!
      if community = Community.find_by(name: request.subdomain)
        Current.community = community
      end
    end
  end
end
