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
      newuser = User.where(username: user["username"]).first_or_create!(password: user["password"], display_name: user["name"], email: user["email"])
      newuser.user_identifier = 'user_identifier'
      if user["role"] == "admin"
        unless admin.users.include?(newuser)
          admin.users << newuser
          admin.save!
        end
      end

      if user.has_key?("depositor")
        depositor = newuser
      end
    end

    # finished creating users
    ##############################################


    ##############################################
    # Create default administrative set
    ######
    Rake::Task['hyrax:default_admin_set:create'].invoke
    Rake::Task['hyrax:workflow:load'].invoke
    Rake::Task['hyrax:default_collection_types:create'].invoke

    ##############################################
    # Create languages controlled vocabulary
    ######
    Rake::Task['hyrax:controlled_vocabularies:language'].invoke if Qa::Authorities::Local.subauthority_for('languages').all.size == 0
  end
end
