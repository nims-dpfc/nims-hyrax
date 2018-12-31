class ComplexIdentifier < ActiveTriples::Resource
  configure type: ::RDF::Vocab::MODS.IdentifierGroup
  property :identifier, predicate: ::RDF::Vocab::DataCite.hasIdentifier
  property :scheme, predicate: ::RDF::Vocab::DataCite.usesIdentifierScheme
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
end
