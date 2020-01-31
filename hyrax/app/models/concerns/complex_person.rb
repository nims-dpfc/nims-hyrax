class ComplexPerson < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::FOAF.Person
  property :first_name, predicate: ::RDF::Vocab::FOAF.givenName
  property :last_name, predicate: ::RDF::Vocab::FOAF.familyName
  property :name, predicate: ::RDF::Vocab::VCARD.hasName
  property :email, predicate: ::RDF::Vocab::FOAF.mbox
  property :role, predicate: ::RDF::Vocab::MODS.roleRelationship

  property :complex_affiliation, predicate: ::RDF::Vocab::VMD.affiliation, class_name:"ComplexAffiliation"
  accepts_nested_attributes_for :complex_affiliation

  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup, class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :uri, predicate: ::RDF::Vocab::Identifiers.uri

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#person#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
