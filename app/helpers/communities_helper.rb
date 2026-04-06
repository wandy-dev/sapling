module CommunitiesHelper
  def community_domain(community)
    return if community.nil?
    main_domain = ActionMailer::Base.default_url_options[:host]

    domain = community&.custom_domain
    if domain.nil?
      domain = "#{community.name}.#{main_domain}"
    end

    domain
  end
end
