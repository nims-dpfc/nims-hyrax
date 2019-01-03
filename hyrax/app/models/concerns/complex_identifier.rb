class ComplexIdentifier < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::MODS.IdentifierGroup
  property :identifier, predicate: ::RDF::Vocab::DataCite.hasIdentifier
  property :scheme, predicate: ::RDF::Vocab::DataCite.usesIdentifierScheme
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#identifier#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
