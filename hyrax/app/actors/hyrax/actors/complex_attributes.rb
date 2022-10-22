module Hyrax
  module Actors
    module ComplexAttributes
      def apply_save_data_to_curation_concern(env)
        super
        # Clear this, it will be re-added by update_complex_metadata
        env.curation_concern.updated_subresources = []
        env = update_complex_metadata(env, env.curation_concern)
      end

      # Call execute on the ActiveTriple::Resources (ATR), like ComplexInstrument
      # Due to a bug somewhere in ActiveFedora, changes to ATR
      #  are not being committed to the resource graph because they are BufferedTransactions
      # This method runs execute on the graphs of each ATR
      # Additionally adds all ATR to top-level property updates_subresources
      #  this seems to be necessary to get ATR nested within other ATR to update
      def update_complex_metadata(env, resource_to_update)
        complex_attributes.each do |attribute|
          next unless resource_to_update.respond_to?(attribute)
          next if resource_to_update.send(attribute).empty?
          resource_to_update.send(attribute).each do |resource|
            update_complex_metadata(env, resource)
            resource.graph.execute
            resource_to_update.send(attribute.to_s).push(resource)
            env.curation_concern.updated_subresources.push(resource_to_update.send(attribute))
          end
        end
        env
      end

      def complex_attributes
        %w[
          complex_person
          complex_identifier
          complex_rights
          complex_organization
          complex_date
          custom_property
          complex_specimen_type
          complex_version
          complex_relation
          complex_instrument
          complex_affiliation
          manufacturer
          supplier
          custom_property
          complex_structural_feature
          complex_state_of_matter
          complex_shape
          complex_purchase_record
          complex_material_type
          instrument_function
          complex_chemical_composition
          complex_crystallographic_structure
          complex_event
          complex_source
          complex_event_date
          complex_funding_reference
          complex_feature

        ]
      end
    end
  end
end
