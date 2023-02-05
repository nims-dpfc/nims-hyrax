module NIMSRoles
  # Placeholder methods to differentiate NIMS users from external users, if needed
  def authenticated_nims?
    return false if guest?
    #ToDo: Add rule to identify as NIMS users
    true
  end

  def authenticated_external?
    return false if guest?
    #ToDo: Add rule to identify as external users
    true
  end

  def authenticated?
    authenticated_nims? || authenticated_external?
  end
end
