module ProgramsHelper
  def producer?(user, program)
    return false unless user
    produce = UserParticipation.find_by(user_id: user.id, program_id: program.id)
    produce.present?
  end

  def invite_button
    action_name == "show" ? "programs/invite_button" : "shared/nil"
  end
end
