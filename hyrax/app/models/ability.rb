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

  def curation_concerns_models
    [::Dataset, ::Publication]
  end

  def create_content
    # only NIMS Researchers may upload new content
    can :create, [::Dataset, ::Publication] if current_user.authenticated_nims?
    can :create, [::Dataset, ::Publication] if current_user.authenticated_external?
    can :create, [::Dataset, ::Publication] if current_user.admin?
  end

  def read_metadata
    can :read_abstract, [::Dataset, ::Publication, ::Collection]
    can :read_alternative_title, [::Dataset, ::Publication]
    # NB: no users can :read_application_number
    # NB: no users can :read_supervisor_approval (though it is visible on the edit form to users with permission to edit)
    cannot :read_supervisor_approval, [::Dataset, ::Publication]
    can :read_creator, [::Dataset, ::Publication]
    can :read_date, [::Dataset, ::Publication, ::Collection]
    can :read_event, [::Dataset, ::Publication]
    can :read_funding_reference, [::Dataset, ::Publication]
    can :read_contact_agent, [::Dataset, ::Publication]
    can :read_identifier, [::Dataset, ::Publication]
    can :read_issue, [::Publication]
    can :read_table_of_contents, [::Publication]
    can :read_keyword, [::Dataset, ::Publication, ::Collection]
    can :read_language, [::Dataset, ::Publication]
    can :read_location, [::Publication]
    can :read_number_of_pages, [::Publication]
    can :read_organization, [::Dataset, ::Publication]
    can :read_publisher, [::Dataset, ::Publication]
    can :read_date_published, [::Dataset, ::Publication]
    can :read_related, [::Dataset, ::Publication]
    can :read_resource_type, [::Dataset, ::Publication, ::Collection] #NB: added Dataset to list
    can :read_rights, [::Dataset, ::Publication, ::Collection]
    can :read_source, [::Dataset, ::Publication] #NB: added Dataset to the list
    can :read_subject, [::Dataset, ::Publication]
    can :read_title, [::Dataset, ::Publication]    # NB: not used in Publication
    can :read_version, [::Dataset, ::Publication]
  end

  def only_admin_can_view_user_list
    if current_user.admin?
      can :index, ::User
    else
      cannot :index, ::User
    end
  end

  def can_create_any_work?
    return false if current_user.email.blank?

    Hyrax.config.curation_concerns.any? do |curation_concern_type|
      can?(:create, curation_concern_type)
    end # && admin_set_with_deposit?
  end
end
