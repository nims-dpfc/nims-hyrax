OAI_CONFIG =
    {
        provider: {
            repository_name: ENV['OAI_REPOSTIORY_NAME'],
            repository_url: ENV['OAI_REPOSITORY_URL'],     # todo: can we get this from the other places that use the base url?
            record_prefix: ENV['OAI_RECORD_PREFIX'],
            admin_email: ENV['OAI_ADMIN_EMAIL'],
            sample_id: 'x059c7329'
        },
        document: {
            limit: 25,            # number of records returned with each request, default: 15
            supported_formats: %w(oai_dc jpcoar),
            record_filters: [
              # limit access to public records
              'read_access_group_ssim: "public"',
              # Get only those records in deposited workflow state or no workflow state
              # So have to explicitly exclude all others
              '-workflow_state_name_ssim: "initial_deposit"',
              '-workflow_state_name_ssim: "deposit"',
              '-workflow_state_name_ssim: "draft"',
              '-workflow_state_name_ssim: "pending_review"',
              '-workflow_state_name_ssim: "changes_required"',
            ]
        },

    }