class ComplexSource < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::ESciDocPublication.Source

  property :alternative_title, predicate: ::RDF::Vocab::DC.alternative
  property :complex_person, predicate: ::RDF::Vocab::ESciDocPublication.creator,
            class_name:"ComplexPerson"
  accepts_nested_attributes_for :complex_person
  property :end_page, predicate: ::RDF::Vocab::ESciDocPublication['end-page']
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :issue, predicate: ::RDF::Vocab::ESciDocPublication.issue
  property :sequence_number, predicate: ::RDF::Vocab::ESciDocPublication['sequence-number']
  property :start_page, predicate: ::RDF::Vocab::ESciDocPublication['start-page']
  property :title, predicate: ::RDF::Vocab::DC11.title
  property :total_number_of_pages, predicate: ::RDF::Vocab::ESciDocPublication['total-number-of-pages']
  property :volume, predicate: ::RDF::Vocab::ESciDocPublication.volume

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#source#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
