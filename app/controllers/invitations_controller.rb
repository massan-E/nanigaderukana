class InvitationsController < ApplicationController
  before_action :set_program, only: %i[ show new create edit update]
  before_action :authenticate_user!, only: %i[ show new create edit update ]
  before_action :email_registered_user, only: %i[ show new create edit update ]
  before_action :valid_user, only: %i[ edit update ]
  before_action :check_expiration, only: %i[ update ]

  def show
    authorize @program, policy_class: InvitationPolicy
    @expiration_time = @program.expiration_time
  end

  def new
    authorize @program, policy_class: InvitationPolicy
  end

  def create
    authorize @program, policy_class: InvitationPolicy
    @program.create_invitation_digest
    flash[:notice]= "招待リンクを作成しました"
    redirect_to program_invitation_path(@program, @program.invitation_token)
  end

  def edit
    authorize @program, policy_class: InvitationPolicy
  end

  def update
    authorize @program, policy_class: InvitationPolicy
    participation = UserParticipation.new(user: current_user, program: @program)
    if participation.save
      flash[:notice]= "#{@program.title}の制作に参加しました"
      redirect_to @program
    else
      redirect_to @program, danger: "既に制作に参加しています"
    end
  end

  private

    def check_expiration
      if @program.invitation_expired?
        flash[:danger] = "招待リンクが期限切れです"
        redirect_to root_path
      end
    end

    def valid_user
      unless @program && @program.authenticated?(params[:id])
        redirect_to root_url
      end
    end
end
