module CommunityResolver
  extend ActiveSupport::Concern

  included do
    before_action :set_community!

    private

    def set_community!
      # Priority 1: Custom domain (exact match on Host)
      community = Community.find_by(custom_domain: request.host)

      # Priority 2: Subdomain fallback
      community ||= Community.find_by(name: request.subdomain) if request.subdomain.present?

      # Set current community - nil means "all communities" (for example.com)
      Current.community = community
    end
  end
end
