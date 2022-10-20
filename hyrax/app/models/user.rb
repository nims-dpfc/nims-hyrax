class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles
  include NIMSRoles

  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  has_many :uploaded_files, class_name: 'Hyrax::UploadedFile', dependent: :nullify

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :username, :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  # ToDo: Now that we are not using CAS, do we want :validatable module?
  devise ENV.fetch('MDR_DEVISE_AUTH_MODULE', 'database_authenticatable').to_sym,
         :rememberable, :trackable, :lockable
         :omniauthable, :rememberable, :trackable, :lockable, omniauth_providers: [:microsoft]
         # NB: the :validatable module is not compatible with CAS authentication

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    display_name
  end

  def self.find_or_create_system_user(user_key)
    username = user_key.split('@')[0]
    User.find_by('email' => user_key) || User.create!(username: username, email: user_key, password: Devise.friendly_token[0, 20], user_identifier: Noid::Rails::Service.new.mint)
  end

  ## allow omniauth logins - this will create a local user based on an omniauth/shib login
  ## if they haven't logged in before
  def self.from_omniauth(auth_hash)
    sub = auth_hash.dig(:extra, :raw_info, :sub)
    User.find_by(username: sub) || User.create!(
      username: sub,
      email: "#{sub}@example.domain",
      display_name: auth_hash.dig(:extra, :raw_info, :name),
      password: Devise.friendly_token[0, 20],
      user_identifier: sub)
  end

  def ldap_before_save
    # Runs before saving a new user record in the database via LDAP Authentication
    self.email = Devise::LDAP::Adapter.get_ldap_param(username, "mail").first
    self.display_name = Devise::LDAP::Adapter.get_ldap_param(username, "cn").first
    self.employee_type_code = Devise::LDAP::Adapter.get_ldap_param(username, "employeeType").first.try(:first)
    self.password = Devise.friendly_token[0, 20]
  end

  def set_user_identifier
    self.user_identifier = Noid::Rails::Service.new.mint
  end

  def self.from_url_component(component)
    User.find_by(user_identifier: component)
  end

  def mailboxer_email(_object)
    email
  end
end
