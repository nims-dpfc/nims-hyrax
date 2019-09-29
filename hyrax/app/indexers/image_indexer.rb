# Generated via
#  `rails generate hyrax:work Image`
class ImageIndexer < NgdrIndexer
  # Custom indexers for image model
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
  include ComplexField::CustomPropertyIndexer
  include ComplexField::RelationIndexer

  def self.facet_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('instrument', :facetable)
      fields << Solrizer.solr_name('specimen_set', :facetable)
      fields.concat ComplexField::DateIndexer.date_facet_fields
      fields.concat ComplexField::PersonIndexer.person_facet_fields
      fields.concat ComplexField::RightsIndexer.rights_facet_fields
    end
  end

  def self.search_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('instrument', :stored_searchable)
      fields << Solrizer.solr_name('specimen_set', :stored_searchable)
      fields.concat ComplexField::DateIndexer.date_search_fields
      fields.concat ComplexField::IdentifierIndexer.identifier_search_fields
      fields.concat ComplexField::PersonIndexer.person_search_fields
      fields.concat ComplexField::RightsIndexer.rights_search_fields
      fields.concat ComplexField::CustomPropertyIndexer.custom_property_search_fields
    end
  end

  def self.show_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('instrument', :stored_searchable)
      fields << Solrizer.solr_name('specimen_set', :stored_searchable)
      fields.concat ComplexField::DateIndexer.date_show_fields
      fields.concat ComplexField::IdentifierIndexer.identifier_show_fields
      fields.concat ComplexField::PersonIndexer.person_show_fields
      fields.concat ComplexField::RightsIndexer.rights_show_fields
      fields.concat ComplexField::CustomPropertyIndexer.custom_property_show_fields
    end
  end
end
