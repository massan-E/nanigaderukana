class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]

  def index
    @programs = Program.all
  end

  def show
    @letter = Letter.new
    @letter.radio_name = current_user if current_user
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
      redirect_to current_user, notice: "program was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @program.update(program_params)
      redirect_to @program, notice: "program was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program.destroy!

    respond_to do |format|
      format.html { redirect_to programs_path, status: :see_other, notice: "program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_program
      @program = Program.find(params.expect(:id))
    end

    def program_params
      params.expect(program: [ :title, :body ])
    end
end
