class ComplexSoftware < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::SCHEMA.SoftwareApplication
  property :description, predicate: ::RDF::Vocab::SCHEMA.description
  property :name, predicate: ::RDF::Vocab::SCHEMA.name
  property :identifier, predicate: ::RDF::Vocab::SCHEMA.identifier
  property :version, predicate: ::RDF::Vocab::SCHEMA.softwareVersion

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#software#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
