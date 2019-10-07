class Ability
  include Hydra::Ability
  include Hyrax::Ability

  # Registered user can only create datasets and publications
  self.ability_logic += [
    :everyone_can_create_dataset,
    :everyone_can_create_publication,
    :only_admin_can_read_user_index
  ]

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end
    if current_user.admin?
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
      # Admin user can create works of all work types
      can :create, curation_concerns_models
    end
    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end

  def everyone_can_create_dataset
    return unless registered_user?
    can :create, [::Dataset]
  end

  def everyone_can_create_publication
    return unless registered_user?
    can :create, [::Publication]
  end

  def only_admin_can_read_user_index
    if current_user.admin?
      can [:index], ::User
    end
  end
end
