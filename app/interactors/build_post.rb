class BuildPost
  include Interactor

  def call
    context.post = context.account.posts.build(context.post_params)
    unless context.post.save
      context.fail!(errors: context.post.errors)
    end
  end
end
