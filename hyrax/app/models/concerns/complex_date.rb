class ComplexDate < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::VCARD.Date
  property :date, predicate: ::RDF::Vocab::Bibframe.eventDate
  property :description, predicate: ::RDF::Vocab::Bibframe.classification

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#date#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end
