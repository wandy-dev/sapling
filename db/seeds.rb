require 'seeder'

# Create a user with 3 posts
user = Seeder.create_user(email: 'asdf@asdf.com', password: 'asdfasdf')
account = Seeder.create_account(user: user)

["Hello world", "here's a post", "and another one"].each do |post_body|
  post = Seeder.create_post(
    account: account,
    post_body: post_body,
    post_attachments: [
      File.open("#{Rails.root}/app/assets/images/onesandzeros.jpg")
    ]
  )

  Seeder.create_favorite(account: account, post: post)
end

post = Seeder.create_post(
  account: account,
  post_body: "Post with replies"
)

# create a user that likes to interact with posts
user = Seeder.create_user(email: 'commenter@asdf.com', password: 'asdfasdf')
account = Seeder.create_account(user: user)

Seeder.create_post(
  account: account,
  post_body: "Cool onesandzeros.jpg",
  in_reply_to: post
)

Seeder.create_post(
  account: account,
  post_body: "I like it a lot",
  in_reply_to: post
)

Seeder.create_favorite(account: account, post: post)
Seeder.create_favorite(account: account, post: post)
Seeder.create_favorite(account: account, post: post)
Seeder.create_favorite(account: account, post: post)
