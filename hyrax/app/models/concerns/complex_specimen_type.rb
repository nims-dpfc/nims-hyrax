class ComplexSpecimenType < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::NimsRdp['Specimen']

  property :chemical_composition, predicate: ::RDF::Vocab::NimsRdp["chemical-composition"],
    class_name:"ComplexChemicalComposition"

  property :crystallographic_structure, predicate: ::RDF::Vocab::NimsRdp["crystallographic-structure"],
    class_name:"ComplexCrystallographicStructure"

  property :description, predicate: ::RDF::Vocab::DC11.description

  property :complex_identifier, predicate: ::RDF::Vocab::MODS.identifierGroup,
            class_name:"ComplexIdentifier"
  accepts_nested_attributes_for :complex_identifier

  property :material_types, predicate: ::RDF::Vocab::NimsRdp["material-types"],
    class_name:"ComplexMaterialType"

  property :purchase_record, predicate: ::RDF::Vocab::NimsRdp["purchase-record"],
            class_name:"ComplexPurchaseRecord"
  accepts_nested_attributes_for :purchase_record

  property :complex_relation, predicate: ::RDF::Vocab::DC.relation,
            class_name:"ComplexRelation"
  accepts_nested_attributes_for :complex_relation

  property :structural_features, predicate: ::RDF::Vocab::NimsRdp["structural-features"],
    class_name:"ComplexStructuralFeature"
  property :form, predicate: ::RDF::Vocab::NimsRdp["form"],
    class_name:"ComplexForm"

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
