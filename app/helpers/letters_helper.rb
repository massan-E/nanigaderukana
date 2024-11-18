module LettersHelper
  def letter_action_path(letter, program)
    letter.persisted? ? edit_letter_path(program) : program_letters_path(program)
  end
end
