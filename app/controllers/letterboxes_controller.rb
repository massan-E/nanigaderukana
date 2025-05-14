class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ edit update destroy ]
  before_action :set_program, only: %i[ index new create edit update destroy ]
  before_action :authenticate_user!, only: %i[ index new create edit update destroy ]
  before_action :email_registered_user, only: %i[ new create edit update destroy ]

  def index
    authorize @program, policy_class: LetterboxPolicy
    @q = @program.letterboxes.ransack(params[:q])
    @result = @q.result(distinct: true)
    @letterboxes = @result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    authorize @program, policy_class: LetterboxPolicy
    @letterbox = Letterbox.new
  end

  def edit
    authorize @program, policy_class: LetterboxPolicy
  end

  def create
    authorize @program, policy_class: LetterboxPolicy
    @letterbox = @program.letterboxes.build(letterbox_params)
    if @letterbox.save
      flash[:notice]= "お便り箱を作成しました"
      redirect_to program_path(@program)
    else
      flash.now[:danger] = "お便り箱の作成に失敗しました、お便り箱作成フォームを確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @program, policy_class: LetterboxPolicy
    if @letterbox.update(letterbox_params)
      flash[:notice]= "お便り箱を編集しました"
      redirect_to @program
    else
      flash.now[:danger] = "お便り箱の編集に失敗しました、お便り箱編集フォームを確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @program, policy_class: LetterboxPolicy
    @letterbox.destroy!
    flash[:notice]= "お便り箱を削除しました"
    redirect_to @program, status: :see_other
  end

  private

    def set_letterbox
      @letterbox = Letterbox.find(params[:id])
    end

    def letterbox_params
      params.require(:letterbox).permit(:title, :body, :publish, :letters_visible)
    end
end
