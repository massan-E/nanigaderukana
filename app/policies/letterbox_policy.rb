class LetterboxPolicy < ApplicationPolicy
  def index?
    user.admin? || program_producer?
  end

  def create?
    user.admin? || program_producer?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
