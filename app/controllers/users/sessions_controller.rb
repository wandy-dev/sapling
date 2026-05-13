# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |resource|
      if Current.community
        session[:current_account] = resource.account
        if Current.account.present? && !Current.account.member_of?(Current.community.id)
          sign_out(resource)
          flash[:alert] = "You are not a member of this community."
          flash[:notice] = nil
          redirect_to new_user_session_path and return
        end
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
