class ComplexKeyValue < ActiveTriples::Resource
  configure type: ::RDF::Vocab::NimsRdp['CustomProperty']
  property :label, predicate: ::RDF::Vocab::RDFS.label
  property :description, predicate: ::RDF::Vocab::DC.description
end
