class ComplexInstrument < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Instrument']

  property :alternative_title, predicate: ::RDF::Vocab::DC.alternative

  property :complex_date, predicate: ::RDF::Vocab::NimsRdp["instrument-date"],
            class_name:"ComplexDate"
  accepts_nested_attributes_for :complex_date

  property :description, predicate: ::RDF::Vocab::DC11.description

  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup, class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :instrument_function, predicate: ::RDF::Vocab::NimsRdp["instrument-function"],
            class_name:"ComplexInstrumentFunction"
  accepts_nested_attributes_for :instrument_function

  property :manufacturer, predicate: ::RDF::Vocab::NimsRdp["instrument-manufacturer"],
            class_name:"ComplexOrganization"
   accepts_nested_attributes_for :manufacturer

  property :model_number, predicate: ::RDF::Vocab::NimsRdp["instrument-model-number"]

  property :complex_person, predicate: ::RDF::Vocab::NimsRdp["instrument-operator"], class_name:"ComplexPerson"
  accepts_nested_attributes_for :complex_person

  property :managing_organization, predicate: ::RDF::Vocab::NimsRdp["instrument-organization"],
            class_name:"ComplexOrganization"
  accepts_nested_attributes_for :managing_organization

  property :title, predicate: ::RDF::Vocab::NimsRdp["instrument-title"]

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
