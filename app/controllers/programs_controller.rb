class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ new create edit update destroy ]
  before_action :authorized_user, only: %i[ edit update destroy ]

  def index
    @programs = Program.includes(:user).all
  end

  def show
    @letter = Letter.new
    @letter.radio_name = current_user.name if current_user
    @letter.letterbox_id = params[:letter]&.dig(:letterbox_id)
  end

  def new
    @program = Program.new
  end

  def edit; end

  def create
    @program = current_user.programs.build(program_params)
    if @program.save
      current_user.user_participations.create(program: @program)
      flash[:success] = "program was successfully created."
      redirect_to current_user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      flash[:success] = "program was successfully updated."
      redirect_to @program
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy!
    flash[:success] = "program was successfully destroyed."
    redirect_to programs_path, status: :see_other
  end

  private

    def set_program
      @program = Program.find(params[:id])
    end

    def program_params
      params.require(:program).permit(:title, :body)
    end

    def authorized_user
      unless producer?(current_user, @program) || current_user.admin?
        redirect_to(root_url, status: :see_other)
      end
    end
end
