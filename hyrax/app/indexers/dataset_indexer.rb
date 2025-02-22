# Generated via
#  `rails generate hyrax:work Dataset`
class DatasetIndexer < NgdrIndexer
  # Custom indexers for dataset model
  include ComplexField::IdentifierIndexer
  include ComplexField::CustomPropertyIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
  include ComplexField::OrganizationIndexer
  include ComplexField::InstrumentIndexer
  include ComplexField::InstrumentOperatorIndexer
  include ComplexField::RelationIndexer
  include ComplexField::EventIndexer
  include ComplexField::SourceIndexer
  include ComplexField::SpecimenTypeIndexer
  include ComplexField::ChemicalCompositionIndexer
  include ComplexField::CrystallographicStructureIndexer
  include ComplexField::MaterialTypeIndexer
  include ComplexField::PurchaseRecordIndexer
  include ComplexField::ShapeIndexer
  include ComplexField::StateOfMatterIndexer
  include ComplexField::StructuralFeatureIndexer
  include ComplexField::FundrefIndexer
  include ComplexField::ContactAgentIndexer
  include ComplexField::CrystallographicStructureIndexer
  include ComplexField::FeatureIndexer
  include ComplexField::SoftwareIndexer
  include ComplexField::ComputationalMethodIndexer
  include ComplexField::ExperimentalMethodIndexer

  def self.facet_fields
    # solr fields that will be treated as facets
    super.tap do |fields|
      dataset_facet_fields = [
        'computational_methods',
        'data_origin',
        'properties_addressed',
        'synthesis_and_processing',
        'characterization_methods',
        'specimen_set',
        'material_type'
      ]
      dataset_facet_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :facetable)
      end
      fields.concat ComplexField::PersonIndexer.person_facet_fields
      fields.concat ComplexField::OrganizationIndexer.organization_facet_fields
      fields.concat ComplexField::RightsIndexer.rights_facet_fields
      fields.concat ComplexField::InstrumentIndexer.instrument_facet_fields
      # fields.concat ComplexField::MaterialTypeIndexer.material_type_facet_fields
      fields.concat ComplexField::PurchaseRecordIndexer.purchase_record_facet_fields
      fields.concat ComplexField::StateOfMatterIndexer.state_of_matter_search_fields
      fields.concat ComplexField::StructuralFeatureIndexer.structural_feature_facet_fields
      fields.concat ComplexField::FundrefIndexer.fundref_facet_fields
      fields.concat ComplexField::CrystallographicStructureIndexer.crystallographic_structure_facet_fields
      fields.concat ComplexField::FeatureIndexer.feature_facet_fields
      fields.concat ComplexField::SoftwareIndexer.software_facet_fields
      fields.concat ComplexField::ComputationalMethodIndexer.computational_method_facet_fields
      fields.concat ComplexField::ExperimentalMethodIndexer.experimental_method_facet_fields
    end
  end

  def self.search_fields
    # solr fields that will be used for a search
    super.tap do |fields|
      dataset_search_fields = [
        'alternate_title',
        'characterization_methods',
        'computational_methods',
        'data_origin',
        'origin_system_provenance',
        'properties_addressed',
        'specimen_set',
        'synthesis_and_processing',
        'first_published_url',
        'doi',
        'material_type'
      ]
      dataset_search_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :stored_searchable)
      end
      fields.concat ComplexField::IdentifierIndexer.identifier_search_fields
      fields.concat ComplexField::CustomPropertyIndexer.custom_property_search_fields
      fields.concat ComplexField::PersonIndexer.person_search_fields
      fields.concat ComplexField::RightsIndexer.rights_search_fields
      fields.concat ComplexField::OrganizationIndexer.organization_search_fields
      fields.concat ComplexField::InstrumentIndexer.instrument_search_fields
      fields.concat ComplexField::InstrumentOperatorIndexer.instrument_operator_search_fields
      fields.concat ComplexField::SpecimenTypeIndexer.specimen_type_search_fields
      fields.concat ComplexField::ChemicalCompositionIndexer.chemical_composition_search_fields
      fields.concat ComplexField::CrystallographicStructureIndexer.crystallographic_structure_search_fields
      fields.concat ComplexField::MaterialTypeIndexer.material_type_search_fields
      fields.concat ComplexField::PurchaseRecordIndexer.purchase_record_search_fields
      fields.concat ComplexField::ShapeIndexer.shape_search_fields
      fields.concat ComplexField::StructuralFeatureIndexer.structural_feature_search_fields
      fields.concat ComplexField::FundrefIndexer.fundref_search_fields
      fields.concat ComplexField::CrystallographicStructureIndexer.crystallographic_structure_search_fields
      fields.concat ComplexField::FeatureIndexer.feature_search_fields
      fields.concat ComplexField::SoftwareIndexer.software_search_fields
      fields.concat ComplexField::ComputationalMethodIndexer.computational_method_search_fields
      fields.concat ComplexField::ExperimentalMethodIndexer.experimental_method_search_fields
    end
  end

  def self.show_fields
    # solr fields that will be used to display results on the record page
    super.tap do |fields|
      dataset_show_fields = [
        'alternate_title',
        'characterization_methods',
        'computational_methods',
        'data_origin',
        'origin_system_provenance',
        'properties_addressed',
        'specimen_set',
        'synthesis_and_processing',
        'material_type'
      ]
      dataset_show_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :stored_searchable)
      end
      fields.concat ComplexField::IdentifierIndexer.identifier_show_fields
      fields.concat ComplexField::CustomPropertyIndexer.custom_property_show_fields
      fields.concat ComplexField::PersonIndexer.person_show_fields
      fields.concat ComplexField::RightsIndexer.rights_show_fields
      fields.concat ComplexField::OrganizationIndexer.organization_show_fields
      fields.concat ComplexField::InstrumentIndexer.instrument_show_fields
      fields.concat ComplexField::InstrumentOperatorIndexer.instrument_operator_show_fields
      fields.concat ComplexField::SpecimenTypeIndexer.specimen_type_show_fields
      fields.concat ComplexField::FundrefIndexer.fundref_show_fields
      fields.concat ComplexField::ContactAgentIndexer.contact_agent_show_fields
      fields.concat ComplexField::ChemicalCompositionIndexer.chemical_composition_show_fields
      fields.concat ComplexField::StructuralFeatureIndexer.structural_feature_show_fields
      fields.concat ComplexField::CrystallographicStructureIndexer.crystallographic_structure_show_fields
      fields.concat ComplexField::FeatureIndexer.feature_show_fields
      fields.concat ComplexField::SoftwareIndexer.software_show_fields
      fields.concat ComplexField::ComputationalMethodIndexer.computational_method_show_fields
      fields.concat ComplexField::ExperimentalMethodIndexer.experimental_method_show_fields
    end
  end

  def generate_solr_document
   super.tap do |solr_doc|
     solr_doc['keyword_tesim'] = object.keyword_ordered
     solr_doc['keyword_sim'] = object.keyword_ordered
     solr_doc['managing_organization_tesim'] = object.managing_organization_ordered
     solr_doc['managing_organization_sim'] = object.managing_organization_ordered
     solr_doc['specimen_set_tesim'] = object.specimen_set_ordered
     solr_doc['specimen_set_sim'] = object.specimen_set_ordered
   end
  end

end
