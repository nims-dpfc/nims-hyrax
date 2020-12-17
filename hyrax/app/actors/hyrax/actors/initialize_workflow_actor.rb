module Hyrax
  module Actors
    # Responsible for generating the workflow for the given curation_concern.
    # Done through direct collaboration with the configured Hyrax::Actors::InitializeWorkflowActor.workflow_factory
    #
    # @see Hyrax::Actors::InitializeWorkflowActor.workflow_factory
    # @see Hyrax::Workflow::WorkflowFactory for default workflow factory
    class InitializeWorkflowActor < AbstractActor
      class_attribute :workflow_factory
      self.workflow_factory = ::Hyrax::Workflow::WorkflowFactory

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        next_actor.create(env) && create_workflow(env)
      end

      private

        # @return [TrueClass]
        def create_workflow(env)
          workflow_factory.create(env.curation_concern, env.attributes, env.user)

          # Put the work into a draft workflow state if env.curation_concern.draft? == true
          if env.curation_concern.draft?
            subject = Hyrax::WorkflowActionInfo.new(env.curation_concern, env.user)
            sipity_workflow_action = PowerConverter.convert_to_sipity_action("deposit_draft", scope: subject.entity.workflow) { nil }
            Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
          else
            subject = Hyrax::WorkflowActionInfo.new(env.curation_concern, env.user)
            sipity_workflow_action = PowerConverter.convert_to_sipity_action("deposit", scope: subject.entity.workflow) { nil }
            Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
          end
        end
    end
  end
end
