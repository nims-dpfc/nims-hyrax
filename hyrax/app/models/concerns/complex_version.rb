class ComplexVersion < ActiveTriples::Resource
  configure type: ::RDF::Vocab::DOAP.Version
  property :date, predicate: ::RDF::Vocab::DC.date
  property :description, predicate: ::RDF::Vocab::DC.description
  property :identifier, predicate: ::RDF::Vocab::DC.identifier
  property :version, predicate: ::RDF::Vocab::SKOS.prefLabel
end
