class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]

  def index
    @programs = Program.all
  end

  def show; end

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
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: "program was successfully updated." }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
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
