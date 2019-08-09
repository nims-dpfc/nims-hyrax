class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def orcid
    Rails.logger.debug "OmniauthCallbacksController#orcid: request.env['omniauth.auth']: #{request.env['omniauth.auth']}"
    user = User.from_omniauth(request.env["omniauth.auth"])
    set_flash_message :notice, :success, kind: "ORCID"
    sign_in_and_redirect user
  end
end
