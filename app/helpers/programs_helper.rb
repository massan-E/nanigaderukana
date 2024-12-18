module ProgramsHelper
  def producer?(user, program)
    return false unless user
    produce = UserParticipation.find_by(user_id: user.id, program_id: program.id)
    produce.present?
  end

  def program_card_class
    case action_name
    when "index"
      "col-md-6 col-lg-4"
    when "top"
      "h-100 w-100 p-lg-4 p-2"
    else
      "col-md-6 col-lg-4"
    end
  end

  def set_program
    @program = Program.find(params[:program_id])
  end
end
