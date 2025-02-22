require 'rails_helper'

RSpec.describe SolrDocument do
  let(:model) do
    build(:dataset,
      alternate_title: 'Alternative Title',
      date_published: '2018-02-14',
      complex_identifier_attributes: [{ identifier: ['123456'], label: ['Local'] }],
      complex_instrument_attributes: [{
        complex_identifier_attributes: [{ identifier: ['ewfqwefqwef'] }],
        complex_person_attributes: [{ name: ['operator 1'] }],
        title: 'Instrument 1',
        date_collected: "2018-01-28"
      }],
      complex_organization_attributes: [{
        organization: 'Foo',
        sub_organization: 'Bar',
        purpose: 'org purpose'
      }],
      complex_person_attributes: [
        { name: ['Anamika'], display_order: 0 },
        { name: ['Smith, John'], display_order: 1 },
        { first_name: ['Joe'], last_name: ['Blogg'], display_order: 2 },
      ],
      complex_rights_attributes: [{ rights: 'cc0' }],
      complex_specimen_type_attributes: [{
        complex_chemical_composition_attributes: [{ description: 'chemical composition 1' }]
      }],
      complex_version_attributes: [{ version: '1.0' }],
      characterization_methods: ['Characterization methods'],
      computational_methods: ['computational methods'],
      data_origin: ['data origin'],
      origin_system_provenance: 'Origin A',
      properties_addressed: ['Properties Addressed'],
      complex_relation_attributes: [{
        title: 'A related item',
        url: 'http://example.com/relation',
        complex_identifier_attributes: [{ identifier: ['123456'] }],
        relationship: 'IsPartOf'
      }],
      specimen_set: ['Specimen Set'],
      synthesis_and_processing: ['Synthesis and processing methods'],
      custom_property_attributes: [{ label: 'Full name', description: 'My full name is' }],
      complex_funding_reference_attributes: [{
        funder_identifier: 'f1234',
        funder_name: 'Bank',
        award_number: 'a1234',
        award_uri: 'http://award.com/a1234',
        award_title: 'No free lunch'
      }],
      complex_contact_agent_attributes: [{
        name: 'Kosuke Tanabe',
        email: 'tanabe@example.jp',
        organization: 'NIMS',
        department: 'DPFC'
      }],
      complex_chemical_composition_attributes: [{
        description: 'chemical composition 1',
        complex_identifier_attributes: [{
          identifier: 'chemical_composition/1234567',
          scheme: 'identifier persistent'
        }]
      }],
      complex_structural_feature_attributes: [{
        description: 'structural feature 1',
        complex_identifier_attributes: [{
          identifier: 'structural_feature/1234567',
          scheme: 'identifier persistent'
        }]
      }]
    )
  end
  let(:solr_document) { described_class.new(model.to_solr) }

  describe '#alternate_title' do
    subject { solr_document.alternate_title }
    it { is_expected.to eql ['Alternative Title'] }
  end

  describe '#date_published' do
    subject { solr_document.date_published }
    it { is_expected.to eql ['2018-02-14'] }
  end

  describe '#complex_identifier' do
    let(:complex_identifier) { JSON.parse(solr_document.complex_identifier).first }
    describe 'identifier' do
      subject { complex_identifier['identifier'] }
      it { is_expected.to eql ['123456'] }
    end
    describe 'label' do
      subject { complex_identifier['label'] }
      it { is_expected.to eql ['Local'] }
    end
  end

  describe '#complex_instrument' do
    let(:complex_instrument) {  JSON.parse(solr_document.complex_instrument).first }
    describe 'date_collected' do
      subject { complex_instrument['date_collected'] }
      it { is_expected.to eql ['2018-01-28'] }
    end
    describe 'complex_identifier' do
      subject { complex_instrument['complex_identifier'].first['identifier'] }
      it { is_expected.to eql ['ewfqwefqwef'] }
    end
    describe 'complex_person' do
      subject { complex_instrument['complex_person'].first['name'] }
      it { is_expected.to eql ['operator 1'] }
    end
    describe 'title' do
      subject { complex_instrument['title'] }
      it { is_expected.to eql ['Instrument 1'] }
    end
  end

  describe '#complex_organization' do
    let(:complex_organization) {  JSON.parse(solr_document.complex_organization).first }
    describe 'organization' do
      subject { complex_organization['organization'] }
      it { is_expected.to eql ['Foo'] }
    end
    describe 'sub_organization' do
      subject { complex_organization['sub_organization'] }
      it { is_expected.to eql ['Bar'] }
    end
    describe 'purpose' do
      subject { complex_organization['purpose'] }
      it { is_expected.to eql ['org purpose'] }
    end
  end

  describe '#complex_person' do
    let(:complex_person) { JSON.parse(solr_document.complex_person) }
    describe 'first name' do
      subject { complex_person[0]['name'] }
      it { is_expected.to eql ['Anamika'] }
    end
    describe 'second name' do
      subject { complex_person[1]['name'] }
      it { is_expected.to eql ['Smith, John'] }
    end
    describe 'third last_name' do
      subject { complex_person[2]['last_name'] }
      it { is_expected.to eql ['Blogg'] }
    end
    describe 'third first_name' do
      subject { complex_person[2]['first_name'] }
      it { is_expected.to eql ['Joe'] }
    end
  end

  describe '#ordered_creators' do
    subject { solr_document.ordered_creators }
    it { is_expected.to eql ['Anamika', 'Smith, John', 'Blogg, Joe'] }
  end

  describe '#complex_rights' do
    let(:complex_rights) { JSON.parse(solr_document.complex_rights).first }
    subject { complex_rights['rights'] }
    it { is_expected.to eql ['cc0'] }
  end

  describe '#complex_specimen_type' do
    let(:complex_specimen_type) { JSON.parse(solr_document.complex_specimen_type).first }
    describe 'complex_chemical_composition' do
      subject { complex_specimen_type['complex_chemical_composition'].first['description'] }
      it { is_expected.to eql ['chemical composition 1'] }
    end
  end

  describe '#complex_version' do
    let(:complex_version) { JSON.parse(solr_document.complex_version).first }
    subject { complex_version['version'] }
    it { is_expected.to eql ['1.0'] }
  end

  describe '#characterization_methods' do
    subject { solr_document.characterization_methods }
    it { is_expected.to eql ['Characterization methods'] }
  end

  describe '#computational_methods' do
    subject { solr_document.computational_methods }
    it { is_expected.to eql ['computational methods'] }
  end

  describe '#data_origin' do
    subject { solr_document.data_origin }
    it { is_expected.to eql ['data origin'] }
  end

  describe '#origin_system_provenance' do
    subject { solr_document.origin_system_provenance }
    it { is_expected.to eql ['Origin A'] }
  end

  describe '#properties_addressed' do
    subject { solr_document.properties_addressed }
    it { is_expected.to eql ['Properties Addressed'] }
  end

  describe '#complex_relation' do
    let(:complex_relation) { JSON.parse(solr_document.complex_relation).first }
    describe 'title' do
      subject { complex_relation['title'] }
      it { is_expected.to eql ['A related item'] }
    end
    describe 'url' do
      subject { complex_relation['url'] }
      it { is_expected.to eql ['http://example.com/relation'] }
    end
    describe 'complex_identifier' do
      subject { complex_relation['complex_identifier'].first['identifier'] }
      it { is_expected.to eql ['123456'] }
    end
    describe 'relationship' do
      subject { complex_relation['relationship'] }
      it { is_expected.to eql ['IsPartOf'] }
    end
  end

  describe '#specimen_set' do
    subject { solr_document.specimen_set }
    it { is_expected.to eql ['Specimen Set'] }
  end

  describe '#synthesis_and_processing' do
    subject { solr_document.synthesis_and_processing }
    it { is_expected.to eql ['Synthesis and processing methods'] }
  end

  describe '#custom_property' do
    let(:custom_property) { JSON.parse(solr_document.custom_property).first }
    describe 'label' do
      subject { custom_property['label'] }
      it { is_expected.to eql ['Full name'] }
    end
    describe 'description' do
      subject { custom_property['description'] }
      it { is_expected.to eql ['My full name is'] }
    end
  end

  describe '#complex_event' do
    let(:model) { build(:publication,
      complex_event_attributes: [{
        end_date: '2019-01-01',
        invitation_status: true,
        place: '221B Baker Street',
        start_date: '2018-12-25',
        title: 'A Title'
      }]
    )}
    let(:complex_event) { JSON.parse(solr_document.complex_event).first }
    describe 'end_date' do
      subject { complex_event['end_date'] }
      it { is_expected.to eql ['2019-01-01'] }
    end
    describe 'invitation_status' do
      subject { complex_event['invitation_status'] }
      it { is_expected.to eql [true] }
    end
    describe 'place' do
      subject { complex_event['place'] }
      it { is_expected.to eql ['221B Baker Street'] }
    end
    describe 'start_date' do
      subject { complex_event['start_date'] }
      it { is_expected.to eql ['2018-12-25'] }
    end
    describe 'title' do
      subject { complex_event['title'] }
      it { is_expected.to eql ['A Title'] }
    end
  end

  describe '#issue' do
    let(:model) { build(:publication, issue: 'iss_1') }
    subject { solr_document.issue }
    it { is_expected.to eql ['iss_1'] }
  end

  describe '#place' do
    let(:model) { build(:publication, place: '221B Baker Street') }
    subject { solr_document.place }
    it { is_expected.to eql ['221B Baker Street'] }
  end

  describe '#table_of_contents' do
    let(:model) { build(:publication, table_of_contents: 'Contents A') }
    subject { solr_document.table_of_contents }
    it { is_expected.to eql ['Contents A'] }
  end

  describe '#total_number_of_pages' do
    let(:model) { build(:publication, total_number_of_pages: '12') }
    subject { solr_document.total_number_of_pages }
    it { is_expected.to eql ['12'] }
  end

  describe '#complex_source' do
    let(:model) { build(:publication,
      complex_source_attributes: [{
        alternative_title: 'Sub title for journal',
        article_number: 'a1234',
        end_page: '12',
        issue: '34',
        sequence_number: '1.2.2',
        start_page: '4',
        title: 'Test journal',
        total_number_of_pages: '8',
        volume: '3'
      }]
    )}
    let(:complex_source) { JSON.parse(solr_document.complex_source).first }
    describe 'alternative_title' do
      subject { complex_source['alternative_title'] }
      it { is_expected.to eql ['Sub title for journal'] }
    end
    describe 'article_number' do
      subject { complex_source['article_number'] }
      it { is_expected.to eql ['a1234'] }
    end
    describe 'end_page' do
      subject { complex_source['end_page'] }
      it { is_expected.to eql ['12'] }
    end
    describe 'issue' do
      subject { complex_source['issue'] }
      it { is_expected.to eql ['34'] }
    end
    describe 'sequence_number' do
      subject { complex_source['sequence_number'] }
      it { is_expected.to eql ['1.2.2'] }
    end
    describe 'start_page' do
      subject { complex_source['start_page'] }
      it { is_expected.to eql ['4'] }
    end
    describe 'title' do
      subject { complex_source['title'] }
      it { is_expected.to eql ['Test journal'] }
    end
    describe 'total_number_of_pages' do
      subject { complex_source['total_number_of_pages'] }
      it { is_expected.to eql ['8'] }
    end
    describe 'volume' do
      subject { complex_source['volume'] }
      it { is_expected.to eql ['3'] }
    end
  end

  describe '#persistent_url (Dataset)' do
    let(:model) { build(:dataset, id: '123456', title: ['Test']) }
    subject { solr_document.persistent_url }
    it { is_expected.to eql "http://localhost/concern/datasets/#{solr_document.id}" }
  end

  describe '#persistent_url (Publication)' do
    let(:model) { build(:publication, id: '123456', title: ['Test']) }
    subject { solr_document.persistent_url }
    it { is_expected.to eql "http://localhost/concern/publications/#{solr_document.id}" }
  end

  describe '#complex_funding_reference' do
    let(:complex_funding_reference) { JSON.parse(solr_document.complex_funding_reference).first }
    #         funder_identifier: 'f1234',
    #         funder_name: 'Bank',
    #         award_number: 'a1234',
    #         award_uri: 'http://award.com/a1234'
    #         award_title: 'No free lunch'
    describe 'funder_identifier' do
      subject { complex_funding_reference['funder_identifier'] }
      it { is_expected.to eql ['f1234'] }
    end
    describe 'funder_name' do
      subject { complex_funding_reference['funder_name'] }
      it { is_expected.to eql ['Bank'] }
    end
    describe 'award_number' do
      subject { complex_funding_reference['award_number'] }
      it { is_expected.to eql ['a1234'] }
    end
    describe 'award_uri' do
      subject { complex_funding_reference['award_uri'] }
      it { is_expected.to eql ['http://award.com/a1234'] }
    end
    describe 'award_title' do
      subject { complex_funding_reference['award_title'] }
      it { is_expected.to eql ['No free lunch'] }
    end
  end

  describe '#complex_contact_agent' do
    let(:complex_contact_agent) { JSON.parse(solr_document.complex_contact_agent).first }
    describe 'name' do
      subject { complex_contact_agent['name'] }
      it { is_expected.to eql ['Kosuke Tanabe'] }
    end
    describe 'email' do
      subject { complex_contact_agent['email'] }
      it { is_expected.to eql ['tanabe@example.jp'] }
    end
    describe 'organization' do
      subject { complex_contact_agent['organization'] }
      it { is_expected.to eql ['NIMS'] }
    end
    describe 'department' do
      subject { complex_contact_agent['department'] }
      it { is_expected.to eql ['DPFC'] }
    end
  end

  describe '#complex_chemical_composition' do
    let(:complex_chemical_composition) { JSON.parse(solr_document.complex_chemical_composition).first }
    describe 'description' do
      subject { complex_chemical_composition['description'] }
      it { is_expected.to eql ['chemical composition 1'] }
    end
    describe 'complex_identifier' do
      subject { complex_chemical_composition['complex_identifier'].first['identifier'] }
      it { is_expected.to eql ['chemical_composition/1234567'] }
    end
  end

  describe '#complex_structural_feature' do
    let(:complex_structural_feature) { JSON.parse(solr_document.complex_structural_feature).first }
    describe 'description' do
      subject { complex_structural_feature['description'] }
      it { is_expected.to eql ['structural feature 1'] }
    end
    describe 'complex_identifier' do
      subject { complex_structural_feature['complex_identifier'].first['identifier'] }
      it { is_expected.to eql ['structural_feature/1234567'] }
    end
  end

  describe "bibtex_filename" do
    subject { solr_document.bibtex_filename }
    it { is_expected.to eq("#{ solr_document.id }.bibtex") }
  end

  describe "bibtex using date published" do
    it 'uses date published for year' do
      expect(solr_document.bibtex_year).to eq "2018"
    end

    it 'uses date published for month' do
      expect(solr_document.bibtex_month).to eq "02"
    end
  end

  describe "bibtex using date created" do
    let(:model2) do
      build(:dataset, title: nil, date_published: nil, date_created: ['2017-11-18'])
    end
    let(:solr_document2) { described_class.new(model2.to_solr) }

    it 'uses date created for month' do
      expect(solr_document2.bibtex_month).to eq "11"
    end

    it 'uses date created for year' do
      expect(solr_document2.bibtex_year).to eq "2017"
    end
  end

  describe "bibtex using year published" do
    let(:model2) do
      build(:dataset, title: nil, date_published: "2019", date_created: ['2017-11-18'])
    end
    let(:solr_document2) { described_class.new(model2.to_solr) }

    it 'uses date created for year' do
      expect(solr_document2.bibtex_year).to eq "2019"
    end

    it 'uses date created for month' do
      expect(solr_document2.bibtex_month).to eq ""
    end
  end
end
