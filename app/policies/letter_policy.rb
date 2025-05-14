class LetterPolicy < ApplicationPolicy
  def index?
    user.admin? || program_producer?
  end

  def show?
    user&.admin? || program_producer? || record&.user == user || record.letterbox.letters_visible?
  end

  def create?
    true
  end

  def destroy?
    user.admin? || program_producer?(record.program) || record.user == user
  end
end
