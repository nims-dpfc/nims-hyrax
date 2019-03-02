# Generated via
#  `rails generate hyrax:work Dataset`
class DatasetIndexer < NgdrIndexer
  # Custom indexers for dataset model
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::CustomPropertyIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
  include ComplexField::InstrumentIndexer
  include ComplexField::RelationIndexer
  include ComplexField::SpecimenTypeIndexer

  def self.facet_fields
    super.tap do |fields|
      dataset_facet_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :facetable)
      end
    end
  end

  def self.search_fields
    super.tap do |fields|
      dataset_search_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :stored_searchable)
      end
    end
  end

  def self.show_fields
    super.tap do |fields|
      dataset_show_fields.each do |fld|
        fields << Solrizer.solr_name(fld, :stored_searchable)
      end
    end
  end

  def dataset_facet_fields
    # solr fields that will be treated as facets
    [
      'computational_methods',
      'data_origin',
      'properties_addressed',
      'synthesis_and_processing'
    ]
  end

  def dataset_search_fields
    # solr fields that will be used for a search
    [
      'alternative_title',
      'characterization_methods',
      'computational_methods',
      'data_origin',
      'origin_system_provenance',
      'properties_addressed',
      'specimen_set',
      'synthesis_and_processing',
    ]
  end

  def dataset_show_fields
    # solr fields that will be used to display results on the record page
    dataset_search_fields
  end
end
