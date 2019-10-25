class ComplexSynthesisAndProcessing < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['SynthesisAndProcessing']
  property :additional_explanation, predicate: ::RDF::Vocab::NimsRdp['additional-explanation']
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :instrumentation_site, predicate: ::RDF::Vocab::NimsRdp['instrumentation-site']
  property :processing_environment, predicate: ::RDF::Vocab::NimsRdp['processing-environment']
  property :standarized_procedure_description, predicate: ::RDF::Vocab::NimsRdp['standarized-procedure-description']
  property :process_date, predicate: ::RDF::Vocab::VCARD.Date
  accepts_nested_attributes_for :complex_date

  property :instrument_identifier, predicate: ::RDF::Vocab::NimsRdp['instrument_identifier'],
            class_name: "ComplexIdentifier"
  accepts_nested_attributes_for :instrument_identifier

  property :standarized_procedure, predicate: ::RDF::Vocab::NimsRdp['standarized_procedure'],
            class_name: "ComplexIdentifier"
  accepts_nested_attributes_for :standarized_procedure

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#complex-synthesis-and-processing#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
