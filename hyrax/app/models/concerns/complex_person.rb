class ComplexPerson < ActiveTriples::Resource
  configure type: ::RDF::Vocab::FOAF.Person
  property :first_name, predicate: ::RDF::Vocab::FOAF.givenName
  property :last_name, predicate: ::RDF::Vocab::FOAF.familyName
  property :name, predicate: ::RDF::Vocab::VCARD.hasName
  property :role, predicate: ::RDF::Vocab::MODS.roleRelationship
  property :affiliation, predicate: ::RDF::Vocab::VMD.affiliation
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :uri, predicate: ::RDF::Vocab::Identifiers.uri
end
