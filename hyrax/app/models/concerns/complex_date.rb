class ComplexDate < ActiveTriples::Resource
  configure type: ::RDF::Vocab::VCARD.Date
  property :date, predicate: ::RDF::Vocab::DC.date
  property :description, predicate: ::RDF::Vocab::DC.description
end
