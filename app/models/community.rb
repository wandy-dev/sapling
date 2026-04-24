class Community < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :users, dependent: :nullify
  has_many :community_posts, dependent: :destroy
  has_many :posts, through: :community_posts

  enum :visibility, { public: 0, private: 1 },
    default: :public, prefix: :visibility

  def self.all_hosts
    hosts = []

    hosts += where.not(custom_domain: nil).pluck(:custom_domain)

    main_domain = ActionMailer::Base.default_url_options[:host]
    if main_domain.present?
      where.not(name: nil).pluck(:name).each do |name|
        hosts << "#{name}.#{main_domain}"
      end

      # Base domain for viewing all communities
      hosts << main_domain
    end

    hosts.uniq
  end
end
