class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  protected

  # Override Devise method to redirect to dashboard after signing in
  def after_sign_in_path_for(resource)
    new_path = '/dashboard/my/works'
    sign_in_url = new_user_session_url
    stored_path = stored_location_for(resource)
    stored_path || new_path
  end

  def guest_username_authentication_key(key)
    "guest_" + guest_user_unique_suffix
  end

  def public_user?
    user_signed_in? ? false : true
  end
end
