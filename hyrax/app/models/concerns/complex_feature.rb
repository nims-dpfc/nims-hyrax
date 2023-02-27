class ComplexFeature < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Feature']

  property :description, predicate: ::RDF::Vocab::DC.description
  property :category_vocabulary, predicate: ::RDF::Vocab::NimsRdp['category-vocabulary']
  property :unit_vocabulary, predicate: ::RDF::Vocab::NimsRdp['unit-vocabulary']
  property :value, predicate: ::RDF::Vocab::NimsRdp['value']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#feature#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
