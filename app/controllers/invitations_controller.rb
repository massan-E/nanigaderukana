class InvitationsController < ApplicationController
  before_action :set_program, only: %i[ show new create edit update]
  before_action :logged_in_user, only: %i[ show new create edit update ]
  before_action :authorized_user, only: %i[ show new create ]
  before_action :valid_user, only: %i[ edit update ]

  def show
    @expiration_time = @program.expiration_time
  end

  def new; end

  def create
    @program.create_invitation_digest
    redirect_to program_invitation_path(@program, @program.invitation_token), notice: "招待リンクを作成しました"
  end

  def edit; end

  def update
    participation = UserParticipation.new(user: current_user, program: @program)
    if participation.save
      redirect_to @program, notice: "#{@program.title}の制作に参加しました"
    end
      redirect_to @program, danger: "既に制作に参加しています"
  end

  private

    def check_expiration
      if @program.invitation_expired?
        flash[:danger] = "招待リンクが期限切れです"
        redirect_to root_path
      end
    end

    def valid_user
      unless (@program && @program.authenticated?(params[:id]))
        redirect_to root_url
      end
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