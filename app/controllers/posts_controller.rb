require 'will_paginate/array'

class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :go_landing!

  def index
    @communities = Community.all
    @selected_community = if params[:community]
      Community.find_by(id: params[:community])
    end

    @unhydrated_posts = TimelineService.get_timeline(
      @selected_community,
      current_user
    ).paginate(page: params[:page], per_page: 10)

    @posts = Post.includes(
      :favorites,
      attachments_attachments: [:blob],
      account: { avatar_attachment: :blob },
      replies: [:account]
    ).find(@unhydrated_posts)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @replies = @post.replies
  end

  # GET /posts/new
  def new
    @post = Post.new
    @user_communities = current_user.all_communities
  end

  # GET /posts/1/edit
  def edit
    @user_communities = current_user.all_communities
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.account = current_user.account
    @post.attachments.attach(params[:post][:attachments])

    respond_to do |format|
      if @post.save
        if params[:post][:community_ids].present?
          params[:post][:community_ids].each do |cid|
            CommunityPost.find_or_create_by!(post: @post, community_id: cid)
          end
        end
        format.html {
 redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        if params[:post][:community_ids].present?
          selected = params[:post][:community_ids].map(&:to_i)
          @post.community_posts.where.not(community_id: selected).destroy_all
          selected.each do |cid|
            CommunityPost.find_or_create_by!(post: @post, community_id: cid)
          end
        end
        format.html {
 redirect_to @post, notice: "Post was successfully updated.",
status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html {
 redirect_to posts_path, notice: "Post was successfully deleted.",
status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:body, :in_reply_to_id, :attachments,
:visibility, community_ids: [])
    end
end
