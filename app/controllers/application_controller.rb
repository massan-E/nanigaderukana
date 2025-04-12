class ApplicationController < ActionController::Base
  # allow_browser versions: :modern
  include ProgramsHelper
  include UsersHelper
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "このアクションは許可されていません"
    redirect_to root_path
  end
end
