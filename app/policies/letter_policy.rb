class LetterPolicy < ApplicationPolicy
  def index?
    user.admin? || program_producer?
  end

  def show?
    user.admin? || program_producer? || owner?
  end

  def create?
    true
  end

  def destroy?
    user.admin? || program_producer?(record.program) || owner?
  end
end
