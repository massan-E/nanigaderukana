class ProgramPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    true
  end

  def update?
    user.admin? || program_producer?
  end

  def destroy?
    update?
  end
end
