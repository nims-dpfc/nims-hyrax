# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocumentBehavior
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior
  include Hyrax::SolrDocument::MdrExport
  include Hyrax::SolrDocument::Jpcoar

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Add field_semantics for oai_dc
  field_semantics.merge!(
    contributor: 'complex_person_other_tesim', # @todo - extract anything other than author from complex person, may need new solr field
    creator: 'complex_person_author_tesim',
    date: 'date_tesim',
    # description: 'description_tesim', # hide description/abstract field for OAI-PMH feed
    identifier: 'complex_identifier_ssim',
    language: 'language_tesim',
    publisher: 'publisher_tesim',
    # relation: '', # @todo have a think about what to map here
    relation: 'first_published_url_tesim',
    rights: 'rights_statement_tesim',
    subject: 'keyword_tesim',
    title: 'title_tesim',
    type: 'resource_type_tesim'
  )

  # Using custom extension for content negotiation for ActiveFedora models
  use_extension( ::Hyrax::SolrDocument::ContentNegotiation )

  def alternate_title
    self[Solrizer.solr_name('alternate_title', :stored_searchable)]
  end

  def date_published
    self[Solrizer.solr_name('date_published', :stored_searchable)]
  end

  def complex_identifier
    self[Solrizer.solr_name('complex_identifier', :displayable)]
  end

  def complex_instrument
    self[Solrizer.solr_name('complex_instrument', :displayable)]
  end

  def complex_organization
    self[Solrizer.solr_name('complex_organization', :displayable)]
  end

  def complex_person
    self[Solrizer.solr_name('complex_person', :displayable)]
  end

  def ordered_creators
    val = self[Solrizer.solr_name('complex_person', :displayable)]
    val = val[0] if val.present? and val.kind_of?(Array)
    val = JSON.parse(val) if val.kind_of?(String)
    val = [val] unless val.kind_of?(Array)
    names = []
    val.each do |v|
      if v.dig('name').present? and v['name'][0].present?
        names.append(v['name'][0])
      else
        creator_name = []
        unless v.dig('last_name').blank?
          creator_name << v['last_name'][0]
        end
        unless v.dig('first_name').blank?
          creator_name << v['first_name'][0]
        end
        creator_name = creator_name.join(', ').strip
        if creator_name.present?
          names.append(creator_name)
        end
      end
    end
    names
  end

  def complex_rights
    self[Solrizer.solr_name('complex_rights', :displayable)]
  end

  def complex_specimen_type
    self[Solrizer.solr_name('complex_specimen_type', :displayable)]
  end

  def complex_version
    self[Solrizer.solr_name('complex_version', :displayable)]
  end

  def characterization_methods
    self[Solrizer.solr_name('characterization_methods', :stored_searchable)]
  end

  def computational_methods
    self[Solrizer.solr_name('computational_methods', :stored_searchable)]
  end

  def data_origin
    self[Solrizer.solr_name('data_origin', :stored_searchable)]
  end

  def licensed_date
    self[Solrizer.solr_name('licensed_date', :stored_searchable)]
  end

  def license_description
    self[Solrizer.solr_name('license_description', :stored_searchable)]
  end

  def instrument
    self[Solrizer.solr_name('instrument', :stored_searchable)]
  end

  def origin_system_provenance
    self[Solrizer.solr_name('origin_system_provenance', :stored_searchable)]
  end

  def properties_addressed
    self[Solrizer.solr_name('properties_addressed', :stored_searchable)]
  end

  def complex_relation
    self[Solrizer.solr_name('complex_relation', :displayable)]
  end

  def specimen_set
    self[Solrizer.solr_name('specimen_set', :stored_searchable)]
  end

  def synthesis_and_processing
    self[Solrizer.solr_name('synthesis_and_processing', :stored_searchable)]
  end

  def custom_property
    self[Solrizer.solr_name('custom_property', :displayable)]
  end

  def complex_event
    self[Solrizer.solr_name('complex_event', :displayable)]
  end

  def issue
    self[Solrizer.solr_name('issue', :stored_searchable)]
  end

  def place
    self[Solrizer.solr_name('place', :stored_searchable)]
  end

  def table_of_contents
    self[Solrizer.solr_name('table_of_contents', :stored_searchable)]
  end

  def total_number_of_pages
    self[Solrizer.solr_name('total_number_of_pages', :stored_searchable)]
  end

  def complex_source
    self[Solrizer.solr_name('complex_source', :displayable)]
  end

  def status
    self[Solrizer.solr_name('status', :stored_searchable)]
  end

  def first_published_url
    self[Solrizer.solr_name('first_published_url', :stored_searchable)]
  end

  def manuscript_type
    self[Solrizer.solr_name('manuscript_type', :stored_searchable)]
  end

  def managing_organization
    self[Solrizer.solr_name('managing_organization', :stored_searchable)]
  end

  def doi
    self[Solrizer.solr_name('doi', :stored_searchable)]
  end

  def file_size
    self[Solrizer.solr_name("file_size", 'lts')]
  end

  def material_type
    self[Solrizer.solr_name('material_type', :stored_searchable)]
  end

  def complex_funding_reference
    self[Solrizer.solr_name('complex_funding_reference', :displayable)]
  end

  def complex_contact_agent
    self[Solrizer.solr_name('complex_contact_agent', :displayable)]
  end

  def complex_chemical_composition
    self[Solrizer.solr_name('complex_chemical_composition', :displayable)]
  end

  def complex_structural_feature
    self[Solrizer.solr_name('complex_structural_feature', :displayable)]
  end

  def complex_crystallographic_structure
    self[Solrizer.solr_name('complex_crystallographic_structure', :displayable)]
  end

  def complex_feature
    self[Solrizer.solr_name('complex_feature', :displayable)]
  end

  def complex_software
    self[Solrizer.solr_name('complex_software', :displayable)]
  end

  def complex_computational_method
    self[Solrizer.solr_name('complex_computational_method', :displayable)]
  end

  def complex_experimental_method
    self[Solrizer.solr_name('complex_experimental_method', :displayable)]
  end
end
