require 'rails_helper'
require 'json'
RSpec.describe DatasetIndexer do
  describe 'indexes an alternative title' do
    before do
      obj = build(:dataset, alternative_title: 'Another title')
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
      obj = build(:dataset, complex_date_attributes: dates)
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
    it 'indexes each type as sortbale' do
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
      obj = build(:dataset, complex_identifier_attributes: ids)
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
      obj = build(:dataset, complex_person_attributes: people)
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
      obj = build(:dataset, complex_rights_attributes: rights)
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
      obj = build(:dataset, complex_version_attributes: versions)
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

  describe 'indexes characterization methods' do
    before do
      obj = build(:dataset, characterization_methods: 'Method D')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['characterization_methods_tesim']).to match_array(['Method D'])
    end
  end

  describe 'indexes computational methods' do
    before do
      obj = build(:dataset, computational_methods: 'Method D')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['computational_methods_tesim']).to match_array(['Method D'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['computational_methods_sim']).to match_array(['Method D'])
    end
  end

  describe 'indexes data origin' do
    before do
      obj = build(:dataset, data_origin: ['Origin A', 'Origin B'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['data_origin_tesim']).to match_array(['Origin A', 'Origin B'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['data_origin_sim']).to match_array(['Origin A', 'Origin B'])
    end
  end

  describe 'indexes an instrument active triple resource with all the attributes' do
    before do
      instruments = [{
        complex_date_attributes: [{
          date: ['2018-02-14'],
          description: 'Processed'
        }],
        description: 'Instrument description',
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        manufacturer: 'Manufacturer name',
        complex_person_attributes: [{
          name: ['Name of operator'],
          role: ['Operator']
        }],
        organization: 'Organisation 1',
        title: 'Instrument title 1'
      }, {
        complex_date_attributes: [{
          date: ['2018-03-15'],
          description: 'Processed'
        }],
        description: 'Instrument description 2',
        manufacturer: 'Manufacturer name',
        complex_identifier_attributes: [{
          identifier: ['asdfasdfasdf'],
        }],
        complex_person_attributes: [{
          name: ['Operator 2'],
          role: ['Operator']
        }],
        organization: 'Organisation 2',
        title: 'Instrument title 2'
      }]
      obj = build(:dataset, instrument_attributes: instruments)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('instrument_ssm')
      expect(JSON.parse(@solr_document['instrument_ssm'])).not_to be_empty
    end
    it 'indexes title asstored searchable' do
      expect(@solr_document['instrument_title_tesim']).to match_array(['Instrument title 1', 'Instrument title 2'])
    end
    it 'indexes description as stored searchable' do
      expect(@solr_document['instrument_description_tesim']).to match_array(['Instrument description', 'Instrument description 2'])
    end
    it 'indexes manufacturer as stored searchable' do
      expect(@solr_document['instrument_manufacturer_tesim']).to match_array(['Manufacturer name', 'Manufacturer name'])
    end
    it 'indexes manufactureras facetable' do
      expect(@solr_document['instrument_manufacturer_sim']).to match_array(['Manufacturer name', 'Manufacturer name'])
    end
    it 'indexes identifier as symbol' do
      expect(@solr_document['instrument_identifier_ssim']).to match_array(['ewfqwefqwef', 'asdfasdfasdf'])
    end
    it 'indexes organization as stored searchable' do
      expect(@solr_document['instrument_organization_tesim']).to match_array(['Organisation 1', 'Organisation 2'])
    end
    it 'indexes organization as facetable' do
      expect(@solr_document['instrument_organization_sim']).to match_array(['Organisation 1', 'Organisation 2'])
    end
    it 'indexes date by type as dateable' do
      expect(@solr_document['complex_date_processed_dtsim']).to match_array(["2018-02-14T00:00:00Z", "2018-03-15T00:00:00Z"])
    end
    it 'indexes date by type as sortable' do
      expect(@solr_document['complex_date_processed_dtsi']).to match_array(["2018-02-14T00:00:00Z", "2018-03-15T00:00:00Z"])
    end
    it 'indexes date by type as displayable' do
      expect(@solr_document['complex_date_processed_ssm']).to match_array(["2018-02-14", "2018-03-15"])
    end
    it 'indexes person by role as stored searchable' do
      expect(@solr_document['complex_person_operator_tesim']).to match_array(['Name of operator', 'Operator 2'])
    end
    it 'imdexes person by role as facetable' do
      expect(@solr_document['complex_person_operator_sim']).to match_array(['Name of operator', 'Operator 2'])
    end
  end

  describe 'indexes origin system provenance' do
    before do
      obj = build(:dataset, origin_system_provenance: 'Origin A')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['origin_system_provenance_tesim']).to match_array(['Origin A'])
    end
  end

  describe 'indexes part of' do
    it 'indexes as stored searchable' do
      skip "Not using this field. Raises RSolr::Error::ConnectionRefused when added to index."
      obj = build(:dataset, part_of: ['Another record'])
      @solr_document = obj.to_solr
      expect(@solr_document['part_of_tesim']).to match_array(['Another record'])
    end
  end

  describe 'indexes properties_addressed' do
    before do
      obj = build(:dataset, properties_addressed: ['Property A', 'Yet another property B'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['properties_addressed_tesim']).to match_array(['Property A', 'Yet another property B'])
    end
  end

  describe 'indexes the relation active triple resource with all the attributes' do
    before do
      relationships = [
        {
          title: 'A related item',
          url: 'http://example.com/relation',
          complex_identifier_attributes: [{
            identifier: ['123456'],
            label: ['local']
          }],
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          title: 'A 2nd related item',
          url: 'http://example.com/relation2',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }, {
          title: 'A 3rd relation item',
          url: 'http://example.com/relation3',
          relationship_name: 'Is version of'
        }
      ]
      obj = build(:dataset, complex_relation_attributes: relationships)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_relation_ssm')
      expect(JSON.parse(@solr_document['complex_relation_ssm'])).not_to be_empty
    end
    it 'indexes the title as stored searchable' do
      expect(@solr_document['complex_relation_title_tesim']).to match_array(
        ['A related item', 'A 2nd related item', 'A 3rd relation item'])
    end
    it 'indexes the relationship as facetable' do
      expect(@solr_document['complex_relation_relationship_sim']).to match_array(
        ['Is part of', 'Is part of', 'Is version of'])
    end
    it 'indexes the relation by relationship as stored searchable' do
      expect(@solr_document['complex_relation_is_part_of_tesim']).to match_array(
        ['A related item', 'A 2nd related item'])
      expect(@solr_document['complex_relation_is_version_of_tesim']).to match_array(
        ['A 3rd relation item'])
    end
    it 'indexes the relation by relationship as facetable' do
      expect(@solr_document['complex_relation_is_part_of_sim']).to match_array(
        ['A related item', 'A 2nd related item'])
      expect(@solr_document['complex_relation_is_version_of_sim']).to match_array(
        ['A 3rd relation item'])
    end
  end

  describe 'indexes specimen set' do
    before do
      obj = build(:dataset, specimen_set: 'specimen A')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['specimen_set_tesim']).to match_array(['specimen A'])
    end
  end

  describe 'indexes specimen type with purchase record active triple resource with all the attributes' do
    before do
      specimen_types = [{
        chemical_composition: ['chemical composition 1', 'chemical composition 2'],
        crystallographic_structure: ['crystallographic structure 1', 'crystallographic structure 2'],
        description: 'Description',
        complex_identifier_attributes: [{
          identifier: '1234567'
        }],
        material_types: ['material A', 'material B'],
        purchase_record_attributes: [{
          date: '2018-09-23',
          title: 'Purchase record 1',
          identifier: 'qwerqwer'
        }],
        complex_relation_attributes: [{
          url: 'http://example.com/relation',
          relationship_role: 'is part of'
        }],
        structural_features: ['structural feature 1', 'structural feature 2'],
        title: 'Instrument 1'
      }, {
        chemical_composition: ['chemical composition 3', 'chemical composition 1'],
        crystallographic_structure: ['crystallographic structure 1', 'crystallographic structure 5'],
        description: 'Description 2',
        complex_identifier_attributes: [{
          identifier: '1234567dAD'
        }],
        material_types: ['material A', 'material D'],
        purchase_record_attributes: [{
          date: '2018-12-23',
          title: 'Purchase record 2',
          identifier: 'qwerqwerADSDSa'
        }],
        structural_features: ['structural feature 4', 'structural feature 2'],
        title: 'Instrument 2'
      }]
      obj = build(:dataset, specimen_type_attributes: specimen_types)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('specimen_type_ssm')
      expect(JSON.parse(@solr_document['specimen_type_ssm'])).not_to be_empty
    end
    it 'indexes the title as stored_searchable' do
      expect(@solr_document['specimen_type_tesim']).to match_array(['Instrument 1', 'Instrument 2'])
    end
    it 'indexes description as stored_searchable' do
      expect(@solr_document['specimen_type_description_tesim']).to match_array(
        ['Description', 'Description 2'])
    end
    it 'indexes chemical_composition as stored_searchable' do
      expect(@solr_document['chemical_composition_tesim']).to match_array(
        ['chemical composition 1', 'chemical composition 2', 'chemical composition 3', 'chemical composition 1'])
    end
    it 'indexes crystallographic_structure as stored_searchable' do
      expect(@solr_document['crystallographic_structure_tesim']).to match_array(
        ['crystallographic structure 1', 'crystallographic structure 2',
         'crystallographic structure 1', 'crystallographic structure 5'])
    end
    it 'indexes material_types as stored_searchable' do
      expect(@solr_document['specimen_type_material_types_tesim']).to match_array(
        ['material A', 'material B', 'material A', 'material D'])
    end
    it 'indexes material_types as facetable' do
      expect(@solr_document['specimen_type_material_types_sim']).to match_array(
        ['material A', 'material B', 'material A', 'material D'])
    end
    it 'indexes identifier as symbol' do
      expect(@solr_document['specimen_type_identifier_ssim']).to match_array(
        ['1234567', '1234567dAD'])
    end
    it 'indexes structural_features as stored_searchable' do
      expect(@solr_document['specimen_type_structural_features_tesim']).to match_array(
        ['structural feature 1', 'structural feature 2', 'structural feature 4', 'structural feature 2'])
    end
    it 'indexes structural_features as facetable' do
      expect(@solr_document['specimen_type_structural_features_sim']).to match_array(
        ['structural feature 1', 'structural feature 2', 'structural feature 4', 'structural feature 2'])
    end
    it 'indexes the purchase record title as stored searchable' do
      expect(@solr_document['purchase_record_title_tesim']).to match_array(
        ['Purchase record 1', 'Purchase record 2'])
    end
    it 'indexes the purchase record identifier as symbol' do
      expect(@solr_document['purchase_record_identifier_ssim']).to match_array(
        ['qwerqwer', 'qwerqwerADSDSa'])
    end
    it 'indexes the purchase date as dateable' do
      expect(@solr_document['complex_date_purchased_dtsim']).to match_array(
        ['2018-09-23T00:00:00Z', '2018-12-23T00:00:00Z'])
    end
    it 'indexes the purchase date as sortable' do
      expect(@solr_document['complex_date_purchased_dtsi']).to match_array(
        ['2018-09-23T00:00:00Z', '2018-12-23T00:00:00Z'])
    end
    it 'indexes the purchase date as displayable' do
      expect(@solr_document['complex_date_purchased_ssm']).to match_array(
        ['2018-09-23', '2018-12-23'])
    end
  end

  describe 'indexes synthesis and processing' do
    before do
      obj = build(:dataset, synthesis_and_processing: 'synthesis A')
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['synthesis_and_processing_tesim']).to match_array(['synthesis A'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['synthesis_and_processing_sim']).to match_array(['synthesis A'])
    end
  end

  describe 'indexes a custom property active triple resource with all the attributes' do
    before do
      custom_properties = [
        {
          label: 'property 1',
          description: 'Some description of the property'
        }, {
          label: 'Property 2',
          description: 'Describing second property'
        }, {
          label: 'PROPERTY 2',
          description: 'Describing second property again'
        }
      ]
      obj = build(:dataset, custom_property_attributes: custom_properties)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('custom_property_ssm')
      expect(JSON.parse(@solr_document['custom_property_ssm'])).not_to be_empty
    end
    it 'indexes each type as stored searchable' do
      expect(@solr_document['custom_property_property_1_tesim']).to match_array(
        ['Some description of the property'])
      expect(@solr_document['custom_property_property_2_tesim']).to match_array(
        ['Describing second property', 'Describing second property again'])
    end
  end

end
