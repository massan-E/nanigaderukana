module LetterboxesHelper
  include ProgramsHelper

  def letterbox_action_path(letterbox, program)
    letterbox.present? ? letterbox_path(letterbox) : program_letterboxes_path(program)
  end
end
