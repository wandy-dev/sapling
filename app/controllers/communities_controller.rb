class CommunitiesController < ApplicationController
  before_action :go_landing!
  before_action :set_community, only: [:show]

  def index
    @communities = Community.joins(:memberships).where(
      memberships: { community: current_user.all_communities }
    ).or(Community.visibility_public).distinct
  end

  def show
    @membership = @community.memberships.find_by(user: current_user)
    @is_admin = @membership&.admin? || @membership&.owner?
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.memberships.new(user: current_user, role: :owner)

    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: "Community created!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_community
    @community = Community.find(params.expect(:id))
  end

  def community_params
    params.require(:community).permit(:name, :visibility)
  end
end
