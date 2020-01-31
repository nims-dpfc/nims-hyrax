module Workflow
  module SynchronisePIDs
    ##
    # This is a built in function for workflow, setting the `#state`
    # of the target to the Fedora 'active' status URI
    #
    # @param target [#state] an instance of a model that includes `Hyrax::Suppressible`
    #
    # @return [RDF::Vocabulary::Term] the Fedora Resource Status 'active' term
    def self.call(target:, **)
      puts "Calling sync job later"
      SynchronisePIDsJob.perform_later(target)
    end
  end
end
