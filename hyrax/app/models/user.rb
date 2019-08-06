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

  def self.from_omniauth(auth)
    #Rails.logger.info "auth = #{auth.inspect}"
    Rails.logger.info "auth = #{auth.info.inspect}"
    # Uncomment the debugger above to capture what a shib auth object looks like for testing
    user = find_by(provider: auth.provider, username: auth.uid)
    unless user
      user = User.create!(
        username: auth.uid,
        email: "dummy@example.com",
        password: Devise.friendly_token
      )
    end
    user
  end
end
