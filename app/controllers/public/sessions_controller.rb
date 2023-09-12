# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :is_admission?, only:[:create]
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to posts_path, notice: "ゲストでログインしました"
  end
  
  def after_sign_in_path_for(resource)
    flash[:notice] = "ようこそ、#{current_user.name}さん！"
    posts_path
  end
  
  def is_admission?
    user = User.find_by(email: params[:user][:email])
    if user.is_admission == true
      flash[:notice] = "規約違反によりアカウントは利用停止になっています"
      redirect_to new_user_session_path
    end
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

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
