class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]
  before_action :authenticate_user!, only: %i[ index ]
  before_action :admin_user, only: %i[ index ]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @programs = @user.joined_programs.order(created_at: :desc).page(params[:page]).per(6)
    @letters = @user.letters.includes(:program).page(params[:page]).per(10)
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user) || current_user&.admin?
    end

    def admin_user
      redirect_to root_url, status: :see_other unless current_user&.admin?
    end
end
