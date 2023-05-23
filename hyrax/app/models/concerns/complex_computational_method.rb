class ComplexComputationalMethod < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['ComputationalMethod']

  property :description, predicate: ::RDF::Vocab::DC.description
  property :category_vocabulary, predicate: ::RDF::Vocab::NimsRdp['category-vocabulary']
  property :category_description, predicate: ::RDF::Vocab::NimsRdp['category-description']
  property :calculated_at, predicate: ::RDF::Vocab::NimsRdp['calculated_at']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#computational-method#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
