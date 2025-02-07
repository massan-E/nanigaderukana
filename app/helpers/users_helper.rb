module UsersHelper
  def email_registered_user
    unless current_user&.email.present?
      redirect_to edit_user_registration_path(current_user), alert: "番組を制作、管理するにはemailの登録が必要です"
    end
  end
end
