module UsersHelper
  def email_registered_user
    unless current_user&.email.present?
      redirect_to edit_user_registration_path(current_user), alert: "emailを登録してください"
    end
  end
end
