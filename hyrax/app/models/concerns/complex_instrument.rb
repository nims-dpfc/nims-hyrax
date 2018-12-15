class ComplexInstrument < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Instrument']

  property :alternative_title, predicate: ::RDF::Vocab::DC.alternative

  property :complex_date, predicate: ::RDF::Vocab::DC.date,
            class_name:"ComplexDate"
  accepts_nested_attributes_for :complex_date

  property :description, predicate: ::RDF::Vocab::DC11.description

  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :function_1, predicate: ::RDF::Vocab::NimsRdp["instrument-function-tier1"]

  property :function_2, predicate: ::RDF::Vocab::NimsRdp["instrument-function-tier2"]

  property :manufacturer, predicate: ::RDF::Vocab::NimsRdp["instrument-manufacturer"]

  property :complex_person, predicate: ::RDF::Vocab::NimsRdp["instrument-operator"],
            class_name:"ComplexPerson"
  accepts_nested_attributes_for :complex_person

  property :organization, predicate: ::RDF::Vocab::NimsRdp["instrument-organization"]

  property :title, predicate: ::RDF::Vocab::DC.title

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#instrument#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
