class AttachPostMedia
  include Interactor

  def call
    return unless context.attachments.present?

    context.post.attachments.attach(context.attachments)
  end
end