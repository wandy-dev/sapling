class MembershipsController < ApplicationController
  before_action :go_landing!
  before_action :set_community
  before_action :require_admin!, only: [:index]

  def index
    @memberships = @community.memberships.includes(user: :account)
  end

  def create
    if @community.visibility_public? && !current_user.member_of?(@community.id)
      @membership = @community.memberships.new(user: current_user,
                                               role: :member)

      if @membership.save
        redirect_to @community, notice: "Welcome to #{@community.name}!"
      else
        redirect_to @community, alert: "Could not join community."
      end
    else
      redirect_to @community, alert: "This community is not open for joining."
    end
  end

  private

  def set_community
    @community = Community.find(params.expect(:community_id))
  end

  def require_admin!
    membership = @community.memberships.find_by(user: current_user)
    unless membership&.admin? || membership&.owner?
      redirect_to @community, alert: "Only admins can manage members."
    end
  end
end
