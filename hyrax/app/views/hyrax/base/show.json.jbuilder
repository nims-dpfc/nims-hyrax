model = @curation_concern.class
fields = @curation_concern.class.fields
             .reject { |f| [:has_model].include? f }
             .reject { |f| f == :depositor }
             .reject { |f| f == :description }
             .reject { |f| f == :proxy_depositor }
             .reject { |f| f == :on_behalf_of }
             .reject { |f| f == :supervisor_approval }

j = json.extract! @curation_concern, *[:id] + fields
json.version @curation_concern.etag
