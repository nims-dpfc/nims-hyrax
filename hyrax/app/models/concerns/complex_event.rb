class ComplexEvent < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::ESciDocPublication.Event

  property :end_date, predicate: ::RDF::Vocab::DC.date

  property :invitation_status, predicate: ::RDF::Vocab::XSD.boolean

  property :place , predicate: ::RDF::Vocab::ESciDocPublication.place

  property :start_date, predicate: ::RDF::Vocab::DC.date

  property :title, predicate: ::RDF::Vocab::DC.title

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#event#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end
end