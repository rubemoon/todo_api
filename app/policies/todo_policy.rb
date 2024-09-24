class TodoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user) # Only return todos that belong to the current user
    end
  end

  def create?
    user.present? # Only logged-in users can create todos
  end

  def update?
    user.present? && record.user == user # Only the owner can update their todos
  end

  def destroy?
    user.present? && record.user == user # Only the owner can delete their todos
  end
end
