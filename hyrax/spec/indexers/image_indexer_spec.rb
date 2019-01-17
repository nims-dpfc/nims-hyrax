require 'rails_helper'
require 'json'
RSpec.describe ImageIndexer do
  describe 'indexes an alternative title' do
    before do
      obj = build(:image, alternative_title: 'Another title')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored_searchable' do
      expect(@solr_document['alternative_title_tesim']).to match_array(['Another title'])
    end
  end

  describe 'indexes a date active triple resource with all the attributes' do
    before do
      dates = [
        {
          date: '1988-10-28',
          description: 'http://bibframe.org/vocab/providerDate',
        }, {
          date: '2018-01-01'
        }
      ]
      obj = build(:image, complex_date_attributes: dates)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_date_ssm')
      expect(JSON.parse(@solr_document['complex_date_ssm'])).not_to be_empty
    end
    it 'indexes as dateable' do
      expect(@solr_document['complex_date_dtsim']).to match_array(
        ["1988-10-28T00:00:00Z", "2018-01-01T00:00:00Z"])
    end
    it 'indexes each type as sortable' do
      skip 'this cannot be multi-valued'
      expect(@solr_document['complex_date_submitted_dtsi']).to match_array("1988-10-28T00:00:00Z")
    end
    it 'indexes each type as dateable' do
      expect(@solr_document['complex_date_submitted_dtsim']).to match_array(["1988-10-28T00:00:00Z"])
    end
    it 'indexes each type as displayable' do
      expect(@solr_document['complex_date_submitted_ssm']).to match_array(["1988-10-28"])
    end
  end

  describe 'indexes an identifier active triple resource with all the attributes' do
    before do
      ids = [
        {
          identifier: '0000-0000-0000-0000',
          scheme: 'uri_of_ORCID_scheme',
          label: 'ORCID'
        }, {
          identifier: '1234',
          label: 'Local ID'
        }, {
          identifier: '12345345234',
          label: 'Orcid'
        }
      ]
      obj = build(:image, complex_identifier_attributes: ids)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_identifier_ssm')
      expect(JSON.parse(@solr_document['complex_identifier_ssm'])).not_to be_empty
    end
    it 'indexes as symbol' do
      expect(@solr_document['complex_identifier_ssim']).to match_array(['0000-0000-0000-0000', '1234', '12345345234'])
    end
    it 'indexes each type as symbol' do
      expect(@solr_document['complex_identifier_orcid_ssim']).to match_array(['0000-0000-0000-0000', '12345345234'])
      expect(@solr_document['complex_identifier_local_id_ssim']).to match_array(['1234'])
    end
  end

  describe 'indexes the person active triple resource with all the attributes' do
    before do
      people = [
        {
          first_name: ['Foo'],
          last_name: 'Bar',
          role: "author"
        }, {
          name: 'Big Baz',
          role: "editor"
        }, {
          name: 'Small Buz',
          role: "author"
        }, {
          first_name: ['Moo'],
          last_name: 'Milk',
          name: 'Moo Milk',
          role: "data depositor"
        }
      ]
      obj = build(:image, complex_person_attributes: people)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_person_ssm')
      expect(JSON.parse(@solr_document['complex_person_ssm'])).not_to be_empty
    end
    it 'indexes as facetable' do
      expect(@solr_document['complex_person_sim']).to match_array(['Foo Bar', 'Big Baz', 'Small Buz', 'Moo Milk'])
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['complex_person_tesim']).to match_array(['Foo Bar', 'Big Baz', 'Small Buz', 'Moo Milk'])
    end
    it 'index by role as stored searchable' do
      expect(@solr_document['complex_person_author_tesim']).to match_array(['Foo Bar', 'Small Buz'])
      expect(@solr_document['complex_person_editor_tesim']).to match_array(['Big Baz'])
      expect(@solr_document['complex_person_data_depositor_tesim']).to match_array(['Moo Milk'])
    end
    it 'index by role as facetable' do
      expect(@solr_document['complex_person_author_sim']).to match_array(['Foo Bar', 'Small Buz'])
      expect(@solr_document['complex_person_editor_sim']).to match_array(['Big Baz'])
      expect(@solr_document['complex_person_data_depositor_sim']).to match_array(['Moo Milk'])
    end
  end

  describe 'indexes the rights active triple resource with all the attributes' do
    before do
      rights = [
        {
          date: '2018-02-14',
          rights: 'CC-0',
        },
        {
          rights: 'Some other right'
        }
      ]
      obj = build(:image, complex_rights_attributes: rights)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_rights_ssm')
      expect(JSON.parse(@solr_document['complex_rights_ssm'])).not_to be_empty
    end
    it 'indexes as facetable' do
      expect(@solr_document).to include('complex_rights_sim')
      expect(@solr_document['complex_rights_sim']).to match_array(['CC-0', 'Some other right'])
    end
  end

  describe 'indexes the version active triple resource with all the attributes' do
    before do
      versions = [
        {
          date: '2018-02-14',
          description: 'First version',
          identifier: 'some_id',
          version: '1.0'
        },
        {
          version: '1.1'
        }
      ]
      obj = build(:image, complex_version_attributes: versions)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_version_ssm')
      expect(JSON.parse(@solr_document['complex_version_ssm'])).not_to be_empty
    end
    it 'indexes as symbol' do
      expect(@solr_document['complex_version_ssim']).to match_array(['1.0', '1.1'])
    end
  end

  describe 'indexes part of' do
    it 'indexes as stored searchable' do
      skip "Not using this field. Raises RSolr::Error::ConnectionRefused when added to index."
      obj = build(:image, part_of: ['Another record'])
      @solr_document = obj.to_solr
      expect(@solr_document['part_of_tesim']).to match_array(['Another record'])
    end
  end
end
