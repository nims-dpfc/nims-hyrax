class ComplexCrystallographicStructure < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['CrystallographicStructure']

  property :description, predicate: ::RDF::Vocab::DC.description
  property :category_identifier, predicate: ::RDF::Vocab::NimsRdp['category-identifier']
  property :category_description, predicate: ::RDF::Vocab::NimsRdp['category-description']
  property :specimen_identifier, predicate: ::RDF::Vocab::NimsRdp['specimen-identifier']
  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#crystallographic_structure#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
