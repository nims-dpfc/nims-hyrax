class ComplexMaterialType < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['MaterialType']
  property :material_type, predicate: ::RDF::Vocab::NimsRdp['material-type']
  property :description, predicate: ::RDF::Vocab::DC11.description
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier
  property :material_sub_type, predicate: ::RDF::Vocab::NimsRdp['material-sub-type']

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#material_type#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
