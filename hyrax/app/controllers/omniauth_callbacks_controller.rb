class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def orcid
    Rails.logger.info "OmniauthCallbacksController#orcid: request.env['omniauth.auth']: #{request.env['omniauth.auth']}"
    # had to create the `from_omniauth(auth_hash)` class method on our User model
    user = User.from_omniauth(request.env["omniauth.auth"])
    set_flash_message :notice, :success, kind: "ORCID"
    sign_in_and_redirect user
  end
end
