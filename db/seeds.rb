
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

# Create a user with 3 posts
user = create_user(email: 'asdf@asdf.com', password: 'asdfasdf')
account = create_account(user: user)

["Hello world", "here's a post", "and another one"].each do |post_body|
  post = create_post(
    account: account,
    post_body: post_body,
    post_attachments: [
      File.open("#{Rails.root}/app/assets/images/onesandzeros.jpg")
    ]
  )

  create_favorite(account: account, post: post)
end

post = create_post(
  account: account,
  post_body: "Post with replies"
)

# create a user that likes to interact with posts
user = create_user(email: 'commenter@asdf.com', password: 'asdfasdf')
account = create_account(user: user)

create_post(
  account: account,
  post_body: "Cool onesandzeros.jpg",
  in_reply_to: post
)

create_post(
  account: account,
  post_body: "I like it a lot",
  in_reply_to: post
)

create_favorite(account: account, post: post)
create_favorite(account: account, post: post)
create_favorite(account: account, post: post)
create_favorite(account: account, post: post)
