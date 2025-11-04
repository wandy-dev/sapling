class AccountsController < ApplicationController
  def new
    @account = Account.new(user: current_user)
  end

  def show
    @account = Account.find(params[:id])
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

  def account_params
    params.expect(account: [:display_name, :username, :bio])
  end
end
