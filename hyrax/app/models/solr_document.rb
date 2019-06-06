# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocumentBehavior
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

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

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  include Formats::OaiDc
  include Formats::Jpcoar

  def process_mapping(xml, field, mapping)
    if mapping.present?
      if mapping.is_a?(Array)
        mapping.each do |mapping_item|
          # recurse and process each item in the array
          process_mapping(xml, field, mapping_item)
        end

      elsif mapping.is_a?(Hash)
        if mapping[:field].present?
          Array.wrap(self[mapping[:field]]).each do |unparsed_value|
            value = self.send(mapping[:'function'], unparsed_value, mapping[:'argument'] || '.')
            xml.tag! field, value if value.present?
          end
        elsif mapping[:function].present?
          value = self.send(mapping[:'function'], field, xml)
        else
          puts "WARNING: mapping #{mapping.inspect} is ignored"
        end

      elsif mapping.is_a?(String)
        Array.wrap(self[mapping]).each do |value|
          xml.tag! field, value
        end
      end

    end
  end

  def xml_parse_and_select(unparsed_value, xpath_select)
    # using some caching to avoid re-parsing the same content
    key = unparsed_value.hash
    @parsed_xml ||= {}
    @parsed_xml[key] ||=  Nokogiri::XML(JSON.parse(unparsed_value).to_xml(root: 'root'))

    @parsed_xml[key].xpath(xpath_select)
  end

  def alternative_title
    self[Solrizer.solr_name('alternative_title', :stored_searchable)]
  end

  def complex_date
    self[Solrizer.solr_name('complex_date', :displayable)]
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
end

