module ProgramsHelper
  def producer?(user, program)
    return false unless user
    produce = UserParticipation.find_by(user_id: user.id, program_id: program.id)
    produce.present?
  end
end
