class OmniauthController < Devise::SessionsController
  def new
    if Rails.env.production?
      redirect_to user_orcid_omniauth_authorize_path
    else
      super
    end
  end
end
