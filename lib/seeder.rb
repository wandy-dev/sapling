class Seeder
  class << self
    def create_user(email:, password:)
      user = User.new
      user.email = email
      user.encrypted_password = password
      user.password = password
      user.save!
      user
    end

    def create_account(user:, display_name: 'Feed poster', username: 'poster',
                       bio: 'hello world')
      Account.create(user: user, display_name:, username:, bio:)
    end

    def create_attachment(post:, attachment: nil, filename: "onesandzeros.jpg")
      post.attachments.attach(io: attachment, filename: filename)
    end

    def create_post(account:, post_body:, post_attachments: nil, in_reply_to: nil)
      post = account.posts.build(body: post_body, in_reply_to: in_reply_to)
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
