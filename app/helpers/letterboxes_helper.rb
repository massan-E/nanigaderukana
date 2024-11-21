module LetterboxesHelper
  def letterbox_action_path(program, letterbox)
    letterbox.persisted? ? edit_program_letterbox_path(program, letterbox) : program_letterboxes_path(program, letterbox)
  end
end
