class Ability
  include Hydra::Ability
  include Hyrax::Ability # NB: not the same as the line above!

  # Registered user can only create datasets and publications
  # Only admin can view the user list
  self.ability_logic += [
    :read_metadata,
    :create_content,
    :only_admin_can_view_user_list
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

  def create_content
    # only NIMS Researchers may upload new content
    can :create, [::Dataset, ::Publication, ::Image] if current_user.authenticated_nims_researcher?
  end

  def read_metadata
    can :read_abstract, [::Dataset, ::Image, ::Publication] if current_user.authenticated?
    can :read_alternative_title, [::Dataset, ::Image, ::Publication]
    # NB: no users can :read_application_number
    can :read_creator, [::Dataset, ::Image, ::Publication]
    can :read_date, [::Dataset, ::Image, ::Publication]
    can :read_event, [::Publication]
    can :read_identifier, [::Dataset, ::Image, ::Publication]
    can :read_issue, [::Publication]
    can :read_table_of_contents, [::Publication]
    can :read_keyword, [::Dataset, ::Image, ::Publication]
    can :read_language, [::Dataset, ::Image, ::Publication]
    can :read_location, [::Publication]
    can :read_number_of_pages, [::Publication]
    can :read_organization, [::Dataset, ::Publication]
    can :read_publisher, [::Dataset, ::Image, ::Publication]
    can :read_related, [::Dataset, ::Publication]
    can :read_resource_type, [::Dataset, ::Image, ::Publication] #NB: added Dataset to list
    can :read_rights, [::Dataset, ::Image, ::Publication]
    can :read_source, [::Dataset, ::Publication] #NB: added Dataset to the list
    can :read_subject, [::Dataset, ::Publication, ::Image]  # NB: added Image to list
    can :read_title, [::Dataset, ::Image, ::Publication]    # NB: not used in Publication
    can :read_version, [::Dataset, ::Image, ::Publication]
  end

  def only_admin_can_view_user_list
    if current_user.admin?
      can :index, ::User
    else
      cannot :index, ::User
    end
  end
end
