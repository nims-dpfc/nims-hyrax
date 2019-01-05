namespace :ngdr do
  desc 'Setup Hyrax, will read from specified file usage: ngdr:setup_hyrax["setup.json"]'
  task :"setup_hyrax", [:seedfile] => :environment do |task, args|
    seedfile = args.seedfile
    unless args.seedfile.present?
      seedfile = Rails.root.join("seed","demo.json")
    end

    if (File.exists?(seedfile))
      puts("Running seedfile: #{seedfile}")
    else
      abort("ERROR: missing seedfile: #{seedfile}")
    end

    seed = JSON.parse(File.read(seedfile))

    ##############################################
    # make the requested users
    ######

    depositor = false
    admin = Role.where(name: "admin").first_or_create!
    seed["users"].each do |user|
      newUser = User.where(email: user["email"]).first_or_create!(password: user["password"], display_name: user["name"])

      if user["role"] == "admin"
        unless admin.users.include?(newUser)
          admin.users << newUser
          admin.save!
        end
      end

      if user.has_key?("depositor")
        depositor = newUser
      end
    end

    # finished creating users
    ##############################################


    ##############################################
    # Create administrative sets
    ######

    administrative_sets = {}
    if seed.has_key?("administrative_sets")
      seed["administrative_sets"].each do |administrative_set|
        arguments = {}
        administrative_set["metadata"].each do |key, val|
          arguments[key.to_sym] = val
        end

        as = AdminSet.where(id: administrative_set["id"]).first || AdminSet.create!(
          id: administrative_set["id"],
          **arguments)

        if administrative_set.has_key?("permission_template")
          pt = Hyrax::PermissionTemplate
                   .where(admin_set_id: administrative_set["id"])
                   .first_or_create!

          if administrative_set["permission_template"].has_key?("permission_template_access")
            administrative_set["permission_template"]["permission_template_access"].each do |pta|
              Hyrax::PermissionTemplateAccess
                  .where(permission_template: pt,
                         agent_type: pta["agent_type"],
                         agent_id: pta["agent_id"],
                         access: pta["access"])
                  .first_or_create!
            end
          end
        end

        administrative_sets[administrative_set["id"]] = as
      end
    end

    # finished administrative sets
    ##############################################

    Hyrax::Workflow::WorkflowImporter.load_workflows


    ##############################################
    # Configure workflow_responsabilities
    ######

    if seed.has_key?("workflow_responsibilities")
      seed["workflow_responsibilities"].each do |workflow_responsibility|
        user = User.where(email: workflow_responsibility["user_email"]).first
        agent = Sipity::Agent.where(proxy_for_id: user, proxy_for_type: user.class.name).first_or_create!
        workflow = Sipity::Workflow.where(name: workflow_responsibility["workflow_name"]).first
        workflow.active = true # ensure the one_step_mediated_deposit is active
        workflow.save
        role = Sipity::Role.where(name: workflow_responsibility["role_name"]).first
        workflow_role = Sipity::WorkflowRole.where(workflow: workflow, role: role).first

        if user.present? && agent.present? && workflow.present? && role.present? && workflow_role.present?
          Sipity::WorkflowResponsibility.where(agent: agent, workflow_role: workflow_role).first_or_create!
        else
          abort("Unable to create workflow_responsibility : user: #{user}, agent: #{agent}, workflow: #{workflow}, role: #{role}, workflow_role: #{workflow_role}")
        end
      end
    end

    # finished workflow_responsabilities
    ##############################################


    ##############################################
    # Create some collections
    ######

    cols = {}
    if seed.has_key?("collections")
      seed["collections"].each do |collection|
        arguments = {}
        collection["metadata"].each do |key, val|
          arguments[key.to_sym] = val
        end
        col = Collection.where(id: collection["id"]).first || Collection.create!(
            id: collection["id"],
            edit_users: [depositor],
            depositor: depositor.email,
            **arguments
        )
        cols[collection["id"]] = col
      end
    end

  end
end
