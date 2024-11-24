class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ edit update destroy ]
  before_action :set_program, only: %i[ index new create edit update destroy ]
  before_action :logged_in_user, only: %i[ index new create edit update destroy ]
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
      flash[:success] = "Letterbox was successfully created."
      redirect_to program_path(@program)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @letterbox.update(letterbox_params)
      flash[:success] = "Letterbox was successfully updated."
      redirect_to @program
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letterbox.destroy!
    flash[:success] = "Letterbox was successfully destroyed."
    redirect_to @program, status: :see_other
  end

  private

    def set_letterbox
      @letterbox = Letterbox.find(params[:id])
    end

    def letterbox_params
      params.require(:letterbox).permit(:title)
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
