# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :params

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def program_producer?(target_record = nil)
    return false unless user
    record_to_check = target_record || record
    program_id = record_to_check.try(:program_id) || record_to_check.id
    UserParticipation.exists?(user_id: user.id, program_id: program_id)
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
