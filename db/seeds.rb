
def create_user(email:, password:)
  user = User.new
  user.email = email
  user.encrypted_password = password
  user.password = password
  user.save!
end

create_user(email: 'asdf@asdf.com', password: 'asdfasdf')

account = Account.create(user: user, display_name: 'Feed poster', username: 'poster', bio: 'hello world')

["Hello world", "here's a post", "and another one"].each do |post_body|
  account.posts.create(body: post_body)
end
