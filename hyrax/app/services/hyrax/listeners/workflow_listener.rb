# frozen_string_literal: true

module Hyrax
  module Listeners
    ##
    # Listens for object lifecycle events that require workflow changes and
    # manages workflow accordingly.
    class WorkflowListener
      ##
      # @note respects class attribute configuration at
      #   {Hyrax::Actors::InitializeWorkflowActor.workflow_factory}, but falls
      #   back on {Hyrax::Workflow::WorkflowFactory} to prepare for removal of
      #   Actors
      # @return [#create] default: {Hyrax::Workflow::WorkflowFactory}
      def factory
        if defined?(Hyrax::Actors::InitializeWorkflowActor)
          Hyrax::Actors::InitializeWorkflowActor.workflow_factory
        else
          Hyrax::Workflow::WorkflowFactory
        end
      end

      ##
      # Called when 'object.deposited' event is published
      # @param [Dry::Events::Event] event
      # @return [void]
      def on_object_deposited(event)
        return Rails.logger.warn("Skipping workflow initialization for #{event[:object]}; no user is given\n\t#{event}") if
          event[:user].blank?

        factory.create(event[:object], {}, event[:user])
        determine_workflow_state(event)
      rescue Sipity::StateError, Sipity::ConversionError => err
        # don't error on known sipity error types; log instead
        Rails.logger.error(err)
      end


      private

      def determine_workflow_state(event)
        # Put the work into a draft workflow state if event[:object].draft? == true
        if event[:object].draft?
          subject = Hyrax::WorkflowActionInfo.new(event[:object], event[:user])
          sipity_workflow_action = PowerConverter.convert_to_sipity_action("deposit_draft", scope: subject.entity.workflow) { nil }
          Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
        elsif event[:object].visibility == 'authenticated' # MDR shared / Institution
          subject = Hyrax::WorkflowActionInfo.new(event[:object], event[:user])
          sipity_workflow_action = PowerConverter.convert_to_sipity_action("approve", scope: subject.entity.workflow) { nil }
          Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
        else
          subject = Hyrax::WorkflowActionInfo.new(event[:object], event[:user])
          sipity_workflow_action = PowerConverter.convert_to_sipity_action("deposit", scope: subject.entity.workflow) { nil }
          Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: sipity_workflow_action, comment: nil)
        end
      end
    end
  end
end