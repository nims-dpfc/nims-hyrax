class ApplicationController < ActionController::Base

  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  skip_after_action :discard_flash_if_xhr
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
      # if request.referer != root_path && request.referer != sign_in_url
      #   stored_path || request.referer || new_path
      # else
      #   stored_path || new_path
      # end
      # Trying fix for redirect loop
      stored_path || new_path
    end
end
