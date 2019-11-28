require 'net/ldap'
class UserAuthorisationService
  # This service is called immediately after authentication (see config/initializers/devise.rb). It updates the user's
  # authorisation attributes from an LDAP source (USER_AUTHORISATION_LDAP_HOST). This is necessary as the CAS server
  # does not provide employeeType/email etc.
  # NB: In the future, this service may query a TSV file on a network drive rather than an LDAP server.

  def initialize(user)
    @user = user
  end

  def enabled?
    ENV['USER_AUTHORISATION_LDAP_HOST'].present? &&
        ENV['USER_AUTHORISATION_LDAP_BASE'].present? &&
        ENV['USER_AUTHORISATION_LDAP_ATTRIBUTE'].present?
  end

  def update_attributes
    success = false
    if enabled? && records.length == 1
      records.first.tap do |record|
        @user.update(email: record[:mail]&.first,
                     display_name: record[:cn]&.first,
                     employee_type_code: record[:employeeType]&.first&.first)
        success = true
      end
    else
      puts "ERROR: UserAuthorisationService failed to retrieve user attributes, check USER_AUTHORISATION_LDAP_HOST, USER_AUTHORISATION_LDAP_BASE, USER_AUTHORISATION_LDAP_ATTRIBUTE env vars"
    end
    success
  end

  private

  def server
    @server ||= Net::LDAP.new(host: ENV['USER_AUTHORISATION_LDAP_HOST'], port: ENV.fetch('USER_AUTHORISATION_LDAP_PORT', 389))
  end

  def records
    @records ||= server.search(base: ENV['USER_AUTHORISATION_LDAP_BASE'], filter: Net::LDAP::Filter.eq(ENV['USER_AUTHORISATION_LDAP_ATTRIBUTE'], @user.username))
  end
end
