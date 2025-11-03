class RepliesController < ApplicationController
  before_action :set_post
  before_action :set_reply, only: %i[ show edit update destroy ]

  def index
    @posts = Post.where(in_reply_to: @post).order(created_at: :desc)
  end

  # GET /replies/1 or /replies/1.json
  def show
  end

  # GET /replies/new
  def new
    @reply = Post.new
  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies or /replies.json
  def create
    @post = Post.new(reply_params)
    @post.account = current_user.account

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /replies/1 or /replies/1.json
  def update
    respond_to do |format|
      if @post.update(reply_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1 or /replies/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to replies_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:post_id))
    end

    def set_reply
      @reply = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reply_params
      params.require(:post).permit(:body, :in_reply_to_id)
    end
end
