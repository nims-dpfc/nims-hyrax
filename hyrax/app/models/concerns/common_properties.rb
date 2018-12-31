module CommonProperties
  extend ActiveSupport::Concern
  included do
    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative, multiple: false do |index|
      index.as :stored_searchable
    end
  end
end
