class ComplexRights < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['License']
  property :date, predicate: ::RDF::Vocab::DISCO.startDate
  property :rights, predicate: ::RDF::Vocab::DC.rights
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
  property :license_description, predicate: ::RDF::Vocab::DC.description

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#rights#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
