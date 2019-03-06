# Generated via
#  `rails generate hyrax:work Publication`
class PublicationIndexer < NgdrIndexer
  # Custom indexers for publication model
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::PersonIndexer
  include ComplexField::RightsIndexer
  include ComplexField::VersionIndexer
  include ComplexField::EventIndexer
  include ComplexField::SourceIndexer

  def self.facet_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('place', :facetable)
    end
  end

  def self.search_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('issue', :stored_searchable)
      fields << Solrizer.solr_name('place', :stored_searchable)
      fields << Solrizer.solr_name('table_of_contents', :stored_searchable)
    end
  end

  def self.show_fields
    super.tap do |fields|
      fields << Solrizer.solr_name('issue', :stored_searchable)
      fields << Solrizer.solr_name('place', :stored_searchable)
      fields << Solrizer.solr_name('table_of_contents', :stored_searchable)
    end
  end

end
