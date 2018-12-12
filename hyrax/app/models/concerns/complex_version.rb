class ComplexVersion < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::DOAP.Version
  # ::RDF::URI.new('http://www.w3.org/2002/07/owl#versionInfo')
  property :date, predicate: ::RDF::Vocab::DC.date
  property :description, predicate: ::RDF::Vocab::DC.description
  property :identifier, predicate: ::RDF::Vocab::DC.identifier
  property :version, predicate: ::RDF::Vocab::SKOS.prefLabel

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#version#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
