class ComplexHistory < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['History']
  property :upstream, predicate: ::RDF::Vocab::NimsRdp['upstream']
  property :downstream, predicate: ::RDF::Vocab::NimsRdp['downstream']
  property :complex_event_date, predicate: ::RDF::Vocab::Bibframe.eventDate, class_name: 'ComplexDate'
  accepts_nested_attributes_for :complex_event_date
  property :complex_operator, predicate: ::RDF::Vocab::SIOC.has_administrator, class_name: 'ComplexPerson'
  accepts_nested_attributes_for :complex_operator

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#history#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
