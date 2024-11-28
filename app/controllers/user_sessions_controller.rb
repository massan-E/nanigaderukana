class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in @user
      redirect_to forwarding_url || @user
    else
      flash.now[:danger] = "ユーザー名とパスワードの組み合わせが間違っています"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path, status: :see_other
  end
end
