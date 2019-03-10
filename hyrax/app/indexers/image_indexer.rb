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
    end
  end

  def self.search_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('instrument', :stored_searchable)
      fields << Solrizer.solr_name('specimen_set', :stored_searchable)
    end
  end

  def self.show_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('instrument', :stored_searchable)
      fields << Solrizer.solr_name('specimen_set', :stored_searchable)
    end
  end
end
