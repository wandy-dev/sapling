class ProfilesController < ApplicationController
  before_action :set_account, only: :show

  def new
    @account = Account.new(user: current_user)
  end

  def show
    @posts = @account.posts.paginate(
      page: params[:page], per_page: 3
    ).order(created_at: :desc)
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user

    respond_to do |format|
      if @account.save
        format.html { redirect_to root_path, notice: "Thanks for signing up!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.expect(account: [:display_name, :username, :bio])
  end
end
