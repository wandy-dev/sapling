class UpdatePostAttributes
  include Interactor

  def call
    context.post.update(context.post_params)
  end
end
