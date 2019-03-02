require 'rails_helper'
require 'json'
RSpec.describe PublicationIndexer do
  describe 'indexes an alternative title' do
    before do
      obj = build(:publication, alternative_title: 'Another title')
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

      obj = build(:publication, complex_date_attributes: dates)
      @solr_document = obj.to_solr
      puts @solr_document.keys
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
      obj = build(:publication, complex_identifier_attributes: ids)
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
      obj = build(:publication, complex_person_attributes: people)
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
      obj = build(:publication, complex_rights_attributes: rights)
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
      obj = build(:publication, complex_version_attributes: versions)
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

  describe 'indexes a complex event' do
    before do
      events = [
        {
          end_date: '2019-01-01',
          invitation_status: true,
          place: '221B Baker Street',
          start_date: '2018-12-25',
          title: 'A Title'
        }, {
          end_date: '2019-02-02',
          invitation_status: true,
          place: 'number 32',
          start_date: '2018-12-26',
          title: '2nd Title'
        }, {
          end_date: '2019-03-03',
          invitation_status: true,
          place: 'number 64',
          start_date: '2018-12-27',
          title: '3rd event'
        }
      ]
      obj = build(:publication, complex_event_attributes: events)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_event_ssm')
      expect(JSON.parse(@solr_document['complex_event_ssm'])).not_to be_empty
    end
    it 'indexes title as stored searchable' do
      expect(@solr_document['complex_event_title_tesim']).to match_array(['A Title', '2nd Title', '3rd event'])
    end
    it 'indexes place as stored searchable' do
      expect(@solr_document['complex_event_place_tesim']).to match_array(['221B Baker Street', 'number 32', 'number 64'])
    end
  end

  describe 'indexes issue' do
    before do
      obj = build(:publication, issue: 'Issue D')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['issue_tesim']).to eq ['Issue D']
    end
  end

  describe 'indexes place' do
    before do
      obj = build(:publication, place: '221B Baker street')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['place_tesim']).to eq ['221B Baker street']
    end
    it 'indexes as facetable' do
      expect(@solr_document['place_sim']).to eq ['221B Baker street']
    end
  end

  describe 'indexes table_of_contents' do
    before do
      obj = build(:publication, table_of_contents: 'Contents A')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['table_of_contents_tesim']).to eq ['Contents A']
    end
  end

  describe 'indexes total_number_of_pages' do
    before do
      obj = build(:publication, total_number_of_pages: '12')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['total_number_of_pages_tesim']).to eq ['12']
    end
    it 'indexes as sortable' do
      expect(@solr_document['total_number_of_pages_si']).to eq '12'
    end
  end

  describe 'indexes a complex source' do
    before do
      source = [
        {
          complex_person_attributes: [{
            name: 'AR',
            role: 'Editor'
          }],
          end_page: '12',
          issue: '34',
          sequence_number: '1.2.2',
          start_page: '4',
          title: 'Test journal',
          total_number_of_pages: '8',
          volume: '3'
        }, {
          complex_person_attributes: [{
            name: 'RN',
            role: 'Joint editor'
          }],
          end_page: '47',
          issue: '2.3',
          sequence_number: '2.3.7',
          start_page: '41',
          title: 'Journal 2',
          total_number_of_pages: '7',
          volume: '376'
        }
      ]
      obj = build(:publication, complex_source_attributes: source)
      @solr_document = obj.to_solr
    end
    it 'indexes source as displayable' do
      expect(@solr_document).to include('complex_source_ssm')
      expect(JSON.parse(@solr_document['complex_source_ssm'])).not_to be_empty
    end
    it 'indexes title as stored searchable' do
      expect(@solr_document['complex_source_title_tesim']).to match_array(['Test journal', 'Journal 2'])
    end
    it 'indexes issue as stored searchable' do
      expect(@solr_document['complex_source_issue_tesim']).to match_array(['34', '2.3'])
    end
    it 'indexes sequence_number as stored searchable' do
      expect(@solr_document['complex_source_sequence_number_tesim']).to match_array(['1.2.2', '2.3.7'])
    end
    it 'indexes volume as stored searchable' do
      expect(@solr_document['complex_source_volume_tesim']).to match_array(['3', '376'])
    end
    it 'index by person role as stored searchable' do
      expect(@solr_document['complex_person_editor_tesim']).to match_array(['AR'])
      expect(@solr_document['complex_person_joint_editor_tesim']).to match_array(['RN'])
    end
    it 'index by person role as facetable' do
      expect(@solr_document['complex_person_editor_sim']).to match_array(['AR'])
      expect(@solr_document['complex_person_joint_editor_sim']).to match_array(['RN'])
    end
  end

end
