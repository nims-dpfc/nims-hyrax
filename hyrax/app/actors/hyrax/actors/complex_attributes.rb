module Hyrax
  module Actors
    module ComplexAttributes
      def update(env)
        env = clean_complex_metadata(env)
        super
      end

      def complex_objects
        %w[
          complex_person complex_identifier complex_affiliation complex_organization
          complex_date complex_rights complex_version complex_relation instrument_function
          custom_property complex_instrument manufacturer complex_specimen_type
        ]
      end

      # delete all complex_metadata, it will be re-added during update
      def clean_complex_metadata(env)
        complex_objects.each do |complex|
          if env.attributes["#{complex}_attributes"]
            env.curation_concern[complex].each(&:destroy)
          end
        end
        env
      end
    end
  end
end
