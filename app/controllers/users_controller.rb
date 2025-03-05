class UsersController < ApplicationController
  before_action :set_user, only: %i[ show destroy ]
  before_action :authenticate_user!, only: %i[ index destroy ]

  def index
    @users = User.all.page(params[:page]).per(10)
    authorize @users
  end

  def show
    authorize @user
    @programs = @user.joined_programs.order(created_at: :desc).page(params[:page]).per(6)
    @letters = @user.letters.includes(:program).page(params[:page]).per(10)
  end

  def destroy
    authorize @user
    programs = @user.programs
    @user.destroy!
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_path, status: :see_other
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
