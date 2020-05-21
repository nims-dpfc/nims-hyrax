model = @curation_concern.class
fields = @curation_concern.class.fields
             .reject { |f| [:has_model].include? f }
             .reject { |f| f == :description && current_ability.cannot?(:read_abstract, model) }
             .reject { |f| f == :supervisor_approval && current_ability.cannot?(:read_supervisor_approval, model) }

j = json.extract! @curation_concern, *[:id] + fields
json.version @curation_concern.etag
