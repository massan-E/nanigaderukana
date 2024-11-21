module LetterboxesHelper
  def letterbox_action_path(program, letterbox)
    letterbox.persisted? ? program_letterbox_path(program, letterbox) : program_letterboxes_path(program, letterbox)
  end
end
