namespace :works do
  task create_missing_entities_and_deposit: :environment  do
    admin_user = Role.find_by_name('admin').users.first
    errors = []
    Hyrax.config.curation_concerns.each do |model|
      defected_works = model.all.select{|w| Sipity::Entity.find_by(proxy_for_global_id: w.to_gid.to_s).blank? }

      defected_works.each do |work|
        Hyrax::Workflow::WorkflowFactory.create(work, {}, admin_user)
        subject = Hyrax::WorkflowActionInfo.new(work, admin_user)
        sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
        Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
      rescue Sipity::StateError, Sipity::ConversionError => err
        errors << err
      end
    end

    puts errors
  end
end