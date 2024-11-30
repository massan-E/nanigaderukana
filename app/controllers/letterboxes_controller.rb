class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ edit update destroy ]
  before_action :set_program, only: %i[ index new create edit update destroy ]
  before_action :authenticate_user!, only: %i[ index new create edit update destroy ]
  before_action :authorized_user, only: %i[ new create edit update destroy ]

  def index
    @letterboxes = Letterbox.all
  end

  def new
    @letterbox = Letterbox.new
  end

  def edit; end

  def create
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
    if @letterbox.update(letterbox_params)
      flash[:notice]= "お便り箱を編集しました"
      redirect_to @program
    else
      flash.now[:danger] = "お便り箱の編集に失敗しました、お便り箱編集フォームを確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letterbox.destroy!
    flash[:notice]= "お便り箱を削除しました"
    redirect_to @program, status: :see_other
  end

  private

    def set_letterbox
      @letterbox = Letterbox.find(params[:id])
    end

    def letterbox_params
      params.require(:letterbox).permit(:title, :body)
    end

    def set_program
      @program = Program.find(params[:program_id])
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end
end
