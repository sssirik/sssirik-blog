# frozen_string_literal: true

# pundit polity for application
# https://github.com/varvet/pundit
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # cRud - Read
  def index?
    true
  end

  def show?
    true
  end

  # Crud - Create
  def create?
    !user.nil?
  end

  def new?
    create?
  end

  # crUd - Update
  def update?
    user&.has_role?(:admin) || user == record.user
  end

  def edit?
    update?
  end

  # cruD - Destroy
  def destroy?
    update?
  end

  # Admin panel
  def dashboard?
    user&.has_role? :admin
  end

  def export?
    dashboard?
  end

  def show_in_app?
    dashboard?
  end

  # Some kind of view listing records which a particular user has access to
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user&.has_role? :admin
        scope.all
      else
        scope.where(status: 'public').or(scope.where(user: user))
      end
    end

    private

    attr_reader :user, :scope
  end
end
