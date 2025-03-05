class RandomLetterPolicy < ApplicationPolicy
  def show?
    user.admin? || program_producer?
  end

  def random?
    show?
  end

  def reset?
    show?
  end
end
