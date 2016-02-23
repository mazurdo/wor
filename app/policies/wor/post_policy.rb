class Wor::PostPolicy < ApplicationPolicy
  def show?
    return true if record.published?
    return true if !user.nil? && user.wor_admin?

    return false
  end

  def preview?
    return true if !user.nil? && user.wor_admin?

    return false
  end
end