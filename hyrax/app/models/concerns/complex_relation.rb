class ComplexRelation < ActiveTriples::Resource
  configure type: ::RDF::Vocab::PROV.Association
  property :title, predicate: ::RDF::Vocab::DC.title
  property :url, predicate: ::RDF::Vocab::MODS.locationUrl
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :relationship_name, predicate: ::RDF::Vocab::MODS.roleRelationshipName
  property :relationship_role, predicate: ::RDF::Vocab::MODS.roleRelationshipRole
end
