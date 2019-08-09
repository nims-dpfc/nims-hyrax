class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats


  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :username, :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise ENV.fetch('MDR_DEVISE_AUTH_MODULE', 'database_authenticatable').to_sym,
         :recoverable,
         :rememberable, :trackable, :lockable, #:validatable,
         :omniauthable
  validates :username, presence: true

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end

  def self.find_or_create_system_user(user_key)
    username = user_key.split('@')[0]
    User.find_by('email' => user_key) || User.create!(username: username, email: user_key, password: Devise.friendly_token[0, 20])
  end

  def ldap_before_save
    self.email = Devise::LDAP::Adapter.get_ldap_param(username, "mail").first
    self.password = Devise.friendly_token[0, 20]
    # self.provider = 'nims_ldap'
  end

  def self.from_omniauth(auth)
    Rails.logger.debug "auth = #{auth.inspect}"

    # NIMS-LDAP users
    user = User.find_by(provider: 'nims_ldap', orcid: auth.uid)

    # ORCID users
    user = User.find_by(provider: auth.provider, username: auth.uid) unless user

    # Sign up
    unless user
      if auth.info.email
        user = User.create!(
          username: auth.uid,
          email: auth.email || 'orcid-dummy@example.com',
          # display_name: auth.name,
          password: Devise.friendly_token[0, 20],
          orcid: auth.uid,
          # provider: auth.provider
        )
      end
    end

    user
  end
end
