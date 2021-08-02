require 'rails_helper'

RSpec.describe ::Hyrax::SolrDocument::Jpcoar do
  describe 'export_as_jpcoar_xml' do
    let(:model) { build(:dataset,
                        :with_managing_organization,
                        :with_first_published_url,
                        :with_alternative_title,
                        :with_article_resource_type,
                        :with_description_abstract,
                        :with_keyword,
                        :with_publisher,
                        :with_date_published,
                        :with_rights,
                        :with_detailed_complex_people,
                        :with_complex_source,
                        :with_complex_event,
                        :with_complex_date,
                        :with_complex_identifier,
                        :with_complex_version,
                        :with_complex_relation,
                        ) }
    let(:solr_document) { SolrDocument.new(model.to_solr) }
    let(:out) { File.read(File.join(fixture_path, 'jpcoar.xml')) }
    it 'build jpcoar xml' do
      skip 'Need to test for xml equivalence'
      xml = solr_document.export_as_jpcoar_xml
      expect(xml.gsub(/<to_s\/>/, '')).to eq out.split("\n").map(&:rstrip).map(&:lstrip).join("")
    end
  end
end