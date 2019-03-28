class ComplexStructuralFeature < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['StructuralFeature']
  property :category, predicate: ::RDF::Vocab::NimsRdp.category
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :sub_category, predicate: ::RDF::Vocab::NimsRdp['sub-category']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#structural_feature#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
