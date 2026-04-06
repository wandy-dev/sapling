class Seeder
  class << self
    def create_community(name:, custom_domain: nil)
      Community.find_or_create_by!(name: name) do |community|
        community.custom_domain = custom_domain
      end
    end

    def create_user(email:, password:, community: nil)
      community ||= Community.first || create_community(name: "main")
      user = User.new
      user.email = email
      user.encrypted_password = password
      user.password = password
      user.community = community
      user.save!
      user
    end

    def create_account(user:, display_name: "Feed poster", username: "poster",
                       bio: "hello world")
      Account.create(user: user, display_name:, username:, bio:)
    end

    def create_attachment(post:, attachment: nil, filename: "onesandzeros.jpg")
      post.attachments.attach(io: attachment, filename: filename)
    end

    def create_post(account:, post_body:, post_attachments: nil, in_reply_to: nil, community: nil)
      post = account.posts.build(body: post_body, in_reply_to: in_reply_to)
      post.communities << community if community.present?
      post.save
      if post_attachments.present?
        post_attachments.each do |attachment|
          create_attachment(post: post, attachment: attachment)
        end
      end
      post
    end

    def create_favorite(account:, post:)
      Favorite.create(account: account, post: post)
    end
  end
end
