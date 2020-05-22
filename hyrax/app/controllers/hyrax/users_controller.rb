require_dependency Hyrax::Engine.config.root.join('app', 'controllers', 'hyrax', 'users_controller.rb').to_s

class Hyrax::UsersController
  def index
    authenticate_user! if Flipflop.hide_users_list?
    authorize! :index, ::User
    @users = search(params[:uq])
  end
end
