module NIMSRoles
  def authenticated_nims_researcher?
    unless defined?(@authenticated_nims_researcher)
      if !guest? && employee_type_code.present? && employee_type_code =~ /^(A|G|L|Q|R|S)/i
        @authenticated_nims_researcher = true
      else
        @authenticated_nims_researcher = false
      end
    end
    @authenticated_nims_researcher
  end

  def authenticated_nims_other?
    unless defined?(@authenticated_nims_other)
      if !guest? && employee_type_code.present? && employee_type_code =~ /^(T|Z)/i
        @authenticated_nims_other = true
      else
        @authenticated_nims_other = false
      end
    end
    @authenticated_nims_other
  end

  def authenticated_nims?
    authenticated_nims_researcher? || authenticated_nims_other?
  end

  def authenticated_external?
    # Coming in Phase 3 (June 2020)
    false
  end

  def email_user?
    true if employee_type_code == '60'
  end

  def authenticated?
    authenticated_nims? || authenticated_external?
  end
end
