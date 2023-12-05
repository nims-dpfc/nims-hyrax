class ComplexInstrumentOperator < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::DCAT.contactPoint
  property :name, predicate: ::RDF::Vocab::VCARD.hasName
  property :email, predicate: ::RDF::Vocab::FOAF.mbox
  property :organization, predicate: ::RDF::Vocab::ORG.Organization
  property :department, predicate: ::RDF::Vocab::ORG.OrganizationalUnit

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#instrument-operator#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
