class LetterboxesController < ApplicationController
  before_action :set_letterbox, only: %i[ show edit update destroy ]
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
      redirect_to program_path(@program), notice: "Letterbox was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @letterbox.update(letterbox_params)
      redirect_to @program, notice: "Letterbox was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @letterbox.destroy!
    redirect_to letterboxes_path, status: :see_other, notice: "Letterbox was successfully destroyed."
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
