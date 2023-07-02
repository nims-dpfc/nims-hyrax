class ComplexExperimentalMethod < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['ExperimentalMethod']

  property :description, predicate: ::RDF::Vocab::DC.description
  property :category_vocabulary, predicate: ::RDF::Vocab::NimsRdp['category-vocabulary']
  property :category_description, predicate: ::RDF::Vocab::NimsRdp['category-description']
  property :analysis_field_vocabulary, predicate: ::RDF::Vocab::NimsRdp['analysis-field-vocabulary']
  property :analysis_field_description, predicate: ::RDF::Vocab::NimsRdp['analysis-field-description']
  property :measurement_environment_vocabulary, predicate: ::RDF::Vocab::NimsRdp['measurement-environment-vocabulary']
  property :standarized_procedure_vocabulary, predicate: ::RDF::Vocab::NimsRdp['standarized-procedure-vocabulary']
  property :measured_at, predicate: ::RDF::Vocab::NimsRdp['measured_at']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#experimental-method#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
