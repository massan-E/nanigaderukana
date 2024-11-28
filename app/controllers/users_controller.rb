class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ index edit update destroy ]
  before_action :correct_user, only: %i[ edit update destroy ]
  before_action :admin_user, only: %i[ index ]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @programs = @user.joined_programs.order(created_at: :desc).page(params[:page]).per(6)
    @letters = @user.letters.includes(:program).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to Music Hour!!"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザー登録に失敗しました、ユーザー登録フォームを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザーを編集しました"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user) || current_user&.admin?
    end

    def admin_user
      redirect_to root_url, status: :see_other unless current_user&.admin?
    end
end
