class ComplexSpecimenType < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Specimen']

  property :complex_chemical_composition, predicate: ::RDF::Vocab::NimsRdp["chemical-composition"],
            class_name:"ComplexChemicalComposition"
  accepts_nested_attributes_for :complex_chemical_composition

  property :complex_crystallographic_structure, predicate: ::RDF::Vocab::NimsRdp["crystallographic-structure"],
            class_name:"ComplexCrystallographicStructure"
  accepts_nested_attributes_for :complex_crystallographic_structure

  property :description, predicate: ::RDF::Vocab::DC11.description

  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :complex_material_type, predicate: ::RDF::Vocab::NimsRdp["material-type"],
            class_name:"ComplexMaterialType"
  accepts_nested_attributes_for :complex_material_type

  property :complex_purchase_record, predicate: ::RDF::Vocab::NimsRdp["purchase-record"],
            class_name:"ComplexPurchaseRecord"
  accepts_nested_attributes_for :complex_purchase_record

  property :complex_relation, predicate: ::RDF::Vocab::DC.relation,
            class_name:"ComplexRelation"
  accepts_nested_attributes_for :complex_relation

  property :complex_structural_feature, predicate: ::RDF::Vocab::NimsRdp["structural-feature"],
            class_name:"ComplexStructuralFeature"
  accepts_nested_attributes_for :complex_structural_feature

  property :complex_state, predicate: ::RDF::Vocab::NimsRdp["state-of-matter"],
            class_name:"ComplexStateOfMatter"
  accepts_nested_attributes_for :complex_state

  property :complex_shape, predicate: ::RDF::Vocab::NimsRdp["shape"],
            class_name:"ComplexShape"
  accepts_nested_attributes_for :complex_shape

  property :title, predicate: ::RDF::Vocab::NimsRdp["specimen-title"]

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#specimen#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
