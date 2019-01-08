namespace :ngdr do
  desc 'Setup Hyrax, will read from specified file usage: ngdr:setup_hyrax["setup.json"]'
  task :"setup_hyrax", [:seedfile] => :environment do |task, args|
    seedfile = args.seedfile
    unless args.seedfile.present?
      seedfile = Rails.root.join("seed","setup.json")
    end

    if (File.exists?(seedfile))
      puts("Running hyrax setup from seedfile: #{seedfile}")
    else
      abort("ERROR: missing seedfile for hyrax setup: #{seedfile}")
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
    # Create default administrative set
    ######
    #

    AdminSet.find_or_create_default_admin_set_id

  end
end
