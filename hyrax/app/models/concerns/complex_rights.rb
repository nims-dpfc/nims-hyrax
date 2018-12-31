class ComplexRights < ActiveTriples::Resource
  configure type: ::RDF::Vocab::NimsRdp['License']
  property :date, predicate: ::RDF::Vocab::DC.date
  property :rights, predicate: ::RDF::Vocab::DC.rights
end
