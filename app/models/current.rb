class Current < ActiveSupport::CurrentAttributes
  attribute :community, :user

  def user=(user)
    super
    self.community = user.community
  end
end
