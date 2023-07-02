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
        }, {
          description: 'http://bibframe.org/vocab/changeDate'
        }, {
          description: 'http://purl.org/dc/terms/dateAccepted',
          date: ''
        }
      ]
      obj = build(:dataset, complex_date_attributes: dates)
      @solr_document = obj.to_solr
    end
    it 'rejects blank dates' do
      expect(@solr_document).not_to include('complex_date_updated_ssm')
      expect(@solr_document).not_to include('complex_year_updated_sim')
      expect(@solr_document).not_to include('complex_date_accepted_ssm')
      expect(@solr_document).not_to include('complex_year_accepted_sim')
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_date_ssm')
      expect(JSON.parse(@solr_document['complex_date_ssm'])).not_to be_empty
    end
    it 'indexes as dateable' do
      expect(@solr_document['complex_date_dtsim']).to match_array(
        ["1988-10-28T00:00:00Z", "2018-01-01T00:00:00Z"])
    end
    it 'indexes year as facetable' do
      expect(@solr_document['complex_year_sim']).to match_array(
        ["1988", "2018"])
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
    it 'indexes each year as facetable' do
      expect(@solr_document['complex_year_submitted_sim']).to match_array(["1988"])
    end
  end

  describe 'indexes an identifier active triple resource with all the attributes' do
    before do
      ids = [
        {
          identifier: '0000-0000-0000-0000',
          scheme: 'ORCID'
        }, {
          identifier: '1234',
          scheme: 'identifier local'
        }, {
          identifier: '12345345234',
          scheme: 'Orcid'
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
      expect(@solr_document['complex_identifier_identifier_local_ssim']).to match_array(['1234'])
    end
  end

  describe 'indexes the person active triple resource with all the attributes' do
    before do
      people = [
        {
          first_name: ['Foo'],
          last_name: 'Bar',
          role: "author",
          complex_identifier_attributes: [{
            identifier: 'abcdef',
            scheme: 'Local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Researcher',
            complex_organization_attributes: [{
              organization: 'Org 1',
              sub_organization: 'Sub org 1'
            }]
          }]
        }, {
          name: 'Big Baz',
          role: "editor",
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Editor',
            complex_organization_attributes: [{
              organization: 'Org 1',
              sub_organization: 'Sub org 2'
            }]
          }]
        }, {
          name: 'Joe Blogg',
          role: "author",
          complex_identifier_attributes: [{
            identifier: 'qwerty',
            scheme: 'Local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Professor',
            complex_organization_attributes: [{
              organization: 'Org 1',
              sub_organization: 'Sub org 1'
            }]
          }]
        }, {
          first_name: ['James'],
          last_name: 'Bond',
          name: 'James Bond',
          role: "data depositor",
          complex_identifier_attributes: [{
            identifier: 'asdfgh',
            scheme: 'Local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Department administrator',
            complex_organization_attributes: [{
              organization: 'Org 1',
              sub_organization: 'Sub org 1'
            }]
          }]
        }
      ]
      obj = build(:dataset, complex_person_attributes: people)
      @solr_document = obj.to_solr
    end
    it 'indexes person as displayable' do
      expect(@solr_document).to include('complex_person_ssm')
      expect(JSON.parse(@solr_document['complex_person_ssm'])).not_to be_empty
    end
    it 'indexes name as facetable' do
      expect(@solr_document['complex_person_sim']).to match_array(['Foo Bar', 'Big Baz', 'Joe Blogg', 'James Bond'])
    end
    it 'indexes name as stored searchable' do
      expect(@solr_document['complex_person_tesim']).to match_array(['Foo Bar', 'Big Baz', 'Joe Blogg', 'James Bond'])
    end
    it 'index name by role as stored searchable' do
      expect(@solr_document['complex_person_author_tesim']).to match_array(['Foo Bar', 'Joe Blogg'])
      expect(@solr_document['complex_person_editor_tesim']).to match_array(['Big Baz'])
      expect(@solr_document['complex_person_data_depositor_tesim']).to match_array(['James Bond'])
    end
    it 'index name by role as facetable' do
      expect(@solr_document['complex_person_author_sim']).to match_array(['Foo Bar', 'Joe Blogg'])
      expect(@solr_document['complex_person_editor_sim']).to match_array(['Big Baz'])
      expect(@solr_document['complex_person_data_depositor_sim']).to match_array(['James Bond'])
    end
    it 'indexes identifier as symbol' do
      expect(@solr_document['complex_person_identifier_ssim']).to match_array(['abcdef', '1234567', 'qwerty', 'asdfgh'])
    end
    it 'indexes affiliated organization as facetable' do
      expect(@solr_document['complex_person_organization_sim']).to match_array(['Org 1'])
    end
    it 'indexes affiliated organization as stored searchable' do
      expect(@solr_document['complex_person_organization_tesim']).to match_array(['Org 1'])
    end
    it 'indexes affiliated sub organization as facetable' do
      expect(@solr_document['complex_person_sub_organization_sim']).to match_array(['Sub org 1', 'Sub org 2'])
    end
    it 'indexes affiliated sub organization as stored searchable' do
      expect(@solr_document['complex_person_sub_organization_tesim']).to match_array(['Sub org 1', 'Sub org 2'])
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

  describe 'indexes the new rights statement active triple resource in all variants' do
    before do
      rights_statement = ['https://creativecommons.org/licenses/by-sa/4.0/legalcode']
      obj = build(:dataset, rights_statement: rights_statement)
      @solr_document = obj.to_solr
    end
    it 'indexes the id as searchable' do
      expect(@solr_document).to include('rights_statement_tesim')
      expect(@solr_document['rights_statement_tesim']).to eq ['https://creativecommons.org/licenses/by-sa/4.0/legalcode']
    end
    it 'indexes all the values as searchable' do
      expect(@solr_document).to include('rights_statement_variants_tesim')
      expect(@solr_document['rights_statement_variants_tesim']).to match_array([
         'https://creativecommons.org/licenses/by-sa/4.0/legalcode',
         'Creative Commons Attribution Share Alike 4.0 International',
         'CC-BY-SA-4.0',
         'https://creativecommons.org/licenses/by-sa/4.0/'
       ])
    end
    it 'indexes as facetable' do
      expect(@solr_document).to include('rights_statement_sim')
      expect(@solr_document['rights_statement_sim']).to match_array(['CC-BY-SA-4.0'])
    end
  end

  describe 'indexes the old rights statement active triple resource in all variants' do
    before do
      rights_statement = ['http://rightsstatements.org/vocab/InC/1.0/']
      obj = build(:dataset, rights_statement: rights_statement)
      @solr_document = obj.to_solr
    end
    it 'indexes the id as searchable' do
      expect(@solr_document).to include('rights_statement_tesim')
      expect(@solr_document['rights_statement_tesim']).to eq ['http://rightsstatements.org/vocab/InC/1.0/']
    end
    it 'indexes all the values as searchable' do
      expect(@solr_document).to include('rights_statement_variants_tesim')
      expect(@solr_document['rights_statement_variants_tesim']).to match_array([
         'http://rightsstatements.org/vocab/InC/1.0/',
         'In Copyright'
       ])
    end
    it 'indexes as facetable' do
      expect(@solr_document).to include('rights_statement_sim')
      expect(@solr_document['rights_statement_sim']).to match_array(['In Copyright'])
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

  describe 'indexes the organization active triple resource with all the attributes' do
    before do
      organizations = [
        {
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'org purpose',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }]
        },
        {
          organization: 'Big',
          sub_organization: 'Baz',
          purpose: 'Manufacturer',
          complex_identifier_attributes: [{
            identifier: '1234567890m',
            scheme: 'Local'
          }]
        }
      ]
      obj = build(:dataset, complex_organization_attributes: organizations)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_organization_ssm')
      expect(JSON.parse(@solr_document['complex_organization_ssm'])).not_to be_empty
    end
    it 'indexes organization as stored searchable' do
      expect(@solr_document['complex_organization_tesim']).to match_array(['Foo', 'Big'])
    end
    it 'indexes organization as facetable' do
      expect(@solr_document['complex_organization_sim']).to match_array(['Foo', 'Big'])
    end
    it 'indexes sub organization as stored searchable' do
      expect(@solr_document['complex_sub_organization_tesim']).to match_array(['Bar', 'Baz'])
    end
    it 'indexes sub organization as facetable' do
      expect(@solr_document['complex_sub_organization_sim']).to match_array(['Bar', 'Baz'])
    end
  end

  describe 'indexes characterization methods' do
    before do
      obj = build(:dataset, characterization_methods: ['Method D'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['characterization_methods_tesim']).to match_array(['Method D'])
    end
  end

  describe 'indexes computational methods' do
    before do
      obj = build(:dataset, computational_methods: ['Method D'])
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
        alternative_title: 'Another instrument title',
        complex_date_attributes: [{
          date: ['2018-02-14'],
          description: ['Registered']
        }],
        description: 'Instrument description',
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }],
        instrument_function_attributes: [{
          column_number: 1,
          category: 'some value',
          sub_category: 'some other value',
          description: 'Instrument function description'
        }],
        manufacturer_attributes: [{
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'Manufacturer',
          complex_identifier_attributes: [{
            identifier: '123456789m',
            scheme: 'Local'
          }]
        }],
        model_number: '123xfty',
        complex_person_attributes: [{
          name: ['Name of operator'],
          role: ['Operator'],
          complex_affiliation_attributes: [{
            job_title: 'Technician',
            complex_organization_attributes: [{
              organization: 'Org 1',
              sub_organization: 'Sub org 1'
            }]
          }]
        }],
        managing_organization_attributes: [{
          organization: 'Managing organization name',
          sub_organization: 'BarBar',
          purpose: 'Managing organization',
          complex_identifier_attributes: [{
            identifier: '123456789mo',
            scheme: 'Local'
          }]
        }],
        title: 'Instrument title'
      },{
        alternative_title: 'Another instrument title 2',
        complex_date_attributes: [{
          date: ['2019-02-14'],
          description: ['Registered']
        }],
        description: 'Instrument description 2',
        complex_identifier_attributes: [{
          identifier: ['1234567890'],
          label: ['Local']
        }],
        instrument_function_attributes: [{
          column_number: 1,
          category: 'some value 2',
          sub_category: 'some other value 2',
          description: 'Instrument function description 2'
        }],
        manufacturer_attributes: [{
          organization: 'Big',
          sub_organization: 'Baz',
          purpose: 'Manufacturer',
          complex_identifier_attributes: [{
            identifier: '1234567890m',
            scheme: 'Local'
          }]
        }],
        model_number: 'ABC12E',
        complex_person_attributes: [{
          name: ['Name of operator 2'],
          role: ['Operator'],
          complex_affiliation_attributes: [{
            job_title: 'Technician',
            complex_organization_attributes: [{
              organization: 'Org 2',
              sub_organization: 'Sub org 2'
            }]
          }]
        }],
        managing_organization_attributes: [{
          organization: 'BigBig',
          sub_organization: 'BazBaz',
          purpose: 'Managing organization',
          complex_identifier_attributes: [{
            identifier: '1234567890mo',
            scheme: 'Local'
          }]
        }],
        title: 'Instrument title 2'
      }]
      obj = build(:dataset, complex_instrument_attributes: instruments)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_instrument_ssm')
      expect(JSON.parse(@solr_document['complex_instrument_ssm'])).not_to be_empty
    end
    it 'indexes title as facetable to complex_instrument_sim' do
      expect(@solr_document['complex_instrument_sim']).to match_array(['Instrument title', 'Instrument title 2'])
    end
    it 'indexes title as stored searchable' do
      expect(@solr_document['instrument_title_tesim']).to match_array(['Instrument title', 'Instrument title 2'])
    end
    it 'indexes alternative title as stored searchable' do
      expect(@solr_document['instrument_alternative_title_tesim']).to match_array(['Another instrument title', 'Another instrument title 2'])
    end
    it 'indexes date by type as dateable' do
      expect(@solr_document['complex_date_registered_dtsim']).to match_array(["2018-02-14T00:00:00Z", "2019-02-14T00:00:00Z"])
    end
    it 'indexes date by type as displayable' do
      expect(@solr_document['complex_date_registered_ssm']).to match_array(["2018-02-14", "2019-02-14"])
    end
    it 'indexes description as stored searchable' do
      expect(@solr_document['instrument_description_tesim']).to match_array(['Instrument description', 'Instrument description 2'])
    end
    it 'indexes identifier as symbol' do
      expect(@solr_document['instrument_identifier_ssim']).to match_array(['123456', '1234567890'])
    end
    it 'indexes manufacturer as stored searchable' do
      expect(@solr_document['instrument_manufacturer_tesim']).to match_array(['Foo', 'Big'])
    end
    it 'indexes manufacturer as facetable' do
      expect(@solr_document['instrument_manufacturer_sim']).to match_array(['Foo', 'Big'])
    end
    it 'indexes manufacturer sub organization as stored searchable' do
      expect(@solr_document['instrument_manufacturer_sub_organization_tesim']).to match_array(['Bar', 'Baz'])
    end
    it 'indexes manufacturer sub organization as facetable' do
      expect(@solr_document['instrument_manufacturer_sub_organization_sim']).to match_array(['Bar', 'Baz'])
    end
    it 'indexes model_number as stored_searchable' do
      expect(@solr_document['instrument_model_number_tesim']).to match_array(['123xfty', 'ABC12E'])
    end
    it 'indexes model_number as facetable' do
      expect(@solr_document['instrument_model_number_sim']).to match_array(['123xfty', 'ABC12E'])
    end
    it 'indexes person by role as stored searchable' do
      expect(@solr_document['complex_person_operator_tesim']).to match_array(['Name of operator', 'Name of operator 2'])
    end
    it 'indexes person by role as facetable' do
      expect(@solr_document['complex_person_operator_sim']).to match_array(['Name of operator', 'Name of operator 2'])
    end
    it 'indexes person affiliation by role as stored searchable' do
      expect(@solr_document['complex_person_operator_organization_tesim']).to match_array(["Org 1", "Org 2"])
    end
    it 'indexes person affiliation by role as facetable' do
      expect(@solr_document['complex_person_operator_organization_sim']).to match_array(["Org 1", "Org 2"])
    end
    it 'indexes managing organization as stored searchable' do
      expect(@solr_document['instrument_managing_organization_tesim']).to match_array(['Managing organization name', 'BigBig'])
    end
    it 'indexes managing organization as facetable' do
      expect(@solr_document['instrument_managing_organization_sim']).to match_array(['Managing organization name', 'BigBig'])
    end
    it 'indexes managing sub organization as stored searchable' do
      expect(@solr_document['instrument_managing_sub_organization_tesim']).to match_array(['BarBar', 'BazBaz'])
    end
    it 'indexes managing sub organization as facetable' do
      expect(@solr_document['instrument_managing_sub_organization_sim']).to match_array(['BarBar', 'BazBaz'])
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
          relationship: 'isPartOf'
        }, {
          title: 'A 2nd related item',
          url: 'http://example.com/relation2',
          relationship: 'isPartOf'
        }, {
          title: 'A 3rd relation item',
          url: 'http://example.com/relation3',
          relationship: 'isNewVersionOf'
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
        ['isPartOf', 'isPartOf', 'isNewVersionOf'])
    end
    it 'indexes the relation by relationship as stored searchable' do
      expect(@solr_document['complex_relation_ispartof_tesim']).to match_array(
        ['A related item', 'A 2nd related item'])
      expect(@solr_document['complex_relation_isnewversionof_tesim']).to match_array(
        ['A 3rd relation item'])
    end
    it 'indexes the relation by relationship as facetable' do
      expect(@solr_document['complex_relation_ispartof_sim']).to match_array(
        ['A related item', 'A 2nd related item'])
      expect(@solr_document['complex_relation_isnewversionof_sim']).to match_array(
        ['A 3rd relation item'])
    end
  end

  describe 'indexes specimen set' do
    before do
      obj = build(:dataset, specimen_set: ['specimen A'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['specimen_set_tesim']).to match_array(['specimen A'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['specimen_set_sim']).to match_array(['specimen A'])
    end
  end

  describe 'indexes material type' do
    before do
      obj = build(:dataset, material_type: ['Cu-containing'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['material_type_tesim']).to match_array(['Cu-containing'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['material_type_sim']).to match_array(['Cu-containing'])
    end
  end

  describe 'indexes specimen type with all the attributes' do
    before do
      specimen_types = [
        {
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 1',
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/12345'
            }],
          }],
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic structure 1',
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/12345'],
              label: ['Local']
            }],
          }],
          description: 'Specimen description',
          complex_identifier_attributes: [{
            identifier: 'specimen/12345'
          }],
          complex_material_type_attributes: [{
            description: 'material description',
            material_type: 'some material type',
            material_sub_type: 'some other material sub type',
            complex_identifier_attributes: [{
              identifier: ['material/12345'],
              label: ['Local']
            }],
          }],
          complex_purchase_record_attributes: [{
            date: ['2018-02-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/12345'],
              label: ['Local']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss',
              purpose: 'Supplier',
              complex_identifier_attributes: [{
                identifier: 'supplier/12345',
                scheme: 'Local'
              }]
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar',
              purpose: 'Manufacturer',
              complex_identifier_attributes: [{
                identifier: 'manufacturer/12345',
                scheme: 'Local'
              }]
            }],
            purchase_record_item: ['Item 1'],
            title: 'Purchase record title'
          }],
          complex_shape_attributes: [{
            description: 'shape description',
            complex_identifier_attributes: [{
              identifier: ['shape/12345'],
              label: ['Local']
            }]
          }],
          complex_state_of_matter_attributes: [{
            description: 'state of matter description',
            complex_identifier_attributes: [{
              identifier: ['state/12345'],
              label: ['Local']
            }]
          }],
          complex_structural_feature_attributes: [{
            description: 'structural feature description',
            category: 'structural feature category',
            sub_category: 'structural feature sub category',
            complex_identifier_attributes: [{
              identifier: ['structural_feature/12345'],
              label: ['Local']
            }]
          }],
          title: 'Specimen 1'
        },
        {
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 2',
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/67890'
            }],
          }],
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic structure 2',
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/67890'],
              label: ['Local']
            }],
          }],
          description: 'Specimen description 2',
          complex_identifier_attributes: [{
            identifier: 'specimen/67890'
          }],
          complex_material_type_attributes: [{
            description: 'material description 2',
            material_type: 'some material type 2',
            material_sub_type: 'some other material sub type 2',
            complex_identifier_attributes: [{
              identifier: ['material/67890'],
              label: ['Local']
            }],
          }],
          complex_purchase_record_attributes: [{
            date: ['2019-02-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/67890'],
              label: ['Local']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss 2',
              purpose: 'Supplier',
              complex_identifier_attributes: [{
                identifier: 'supplier/67890',
                scheme: 'Local'
              }]
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar 2',
              purpose: 'Manufacturer',
              complex_identifier_attributes: [{
                identifier: 'manufacturer/67890',
                scheme: 'Local'
              }]
            }],
            purchase_record_item: ['Item 2'],
            title: 'Purchase record title 2'
          },{
            date: ['2019-03-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/asdfg'],
              label: ['Local']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss',
              purpose: 'Supplier',
              complex_identifier_attributes: [{
                identifier: 'supplier/asdfg',
                scheme: 'Local'
              }]
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar',
              purpose: 'Manufacturer',
              complex_identifier_attributes: [{
                identifier: 'manufacturer/12345',
                scheme: 'Local'
              }]
            }],
            purchase_record_item: ['Item 3'],
            title: 'Purchase record title 3'
          }],
          complex_shape_attributes: [{
            description: 'shape description 2',
            complex_identifier_attributes: [{
              identifier: ['shape/67890'],
              label: ['Local']
            }]
          }],
          complex_state_of_matter_attributes: [{
            description: 'state of matter description 2',
            complex_identifier_attributes: [{
              identifier: ['state/67890'],
              label: ['Local']
            }]
          }],
          title: 'Specimen 2'
        }
      ]
      obj = build(:dataset, complex_specimen_type_attributes: specimen_types)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_specimen_type_ssm')
      expect(JSON.parse(@solr_document['complex_specimen_type_ssm'])).not_to be_empty
    end
    it 'indexes the title as stored_searchable' do
      expect(@solr_document['complex_specimen_type_tesim']).to match_array(['Specimen 1', 'Specimen 2'])
    end
    it 'indexes description as stored_searchable' do
      expect(@solr_document['complex_specimen_type_description_tesim']).to match_array(
        ['Specimen description', 'Specimen description 2'])
    end
    it 'indexes identifier as symbol' do
      expect(@solr_document['complex_specimen_type_identifier_ssim']).to match_array(
        ['specimen/12345', 'specimen/67890'])
    end
    it 'indexes crystallographic_structure as stored_searchable' do
      expect(@solr_document['complex_crystallographic_structure_tesim']).to match_array(
        ['crystallographic structure 1', 'crystallographic structure 2'])
    end
    it 'indexes crystallographic_structure identifier as stored_searchable' do
      expect(@solr_document['complex_crystallographic_structure_identifier_ssim']).to match_array(
        ['crystallographic_structure/12345', 'crystallographic_structure/67890'])
    end
    it 'indexes material type as stored_searchable' do
      expect(@solr_document['complex_material_type_tesim']).to match_array(
        ['some material type', 'some material type 2'])
    end
    it 'indexes material type as facetable' do
      expect(@solr_document['complex_material_type_sim']).to match_array(
        ['some material type', 'some material type 2'])
    end
    it 'indexes material type description as stored_searchable' do
      expect(@solr_document['complex_material_type_description_tesim']).to match_array(
        ['material description', 'material description 2'])
    end
    it 'indexes sub material type as stored_searchable' do
      expect(@solr_document['complex_material_sub_type_tesim']).to match_array(
        ['some other material sub type', 'some other material sub type 2'])
    end
    it 'indexes sub material type as facetable' do
      expect(@solr_document['complex_material_sub_type_sim']).to match_array(
        ['some other material sub type', 'some other material sub type 2'])
    end
    it 'indexes material type identifier as symbol' do
      expect(@solr_document['complex_material_type_identifier_ssim']).to match_array(
        ['material/12345', 'material/67890'])
    end
    it 'indexes purchase record item as stored_searchable' do
      expect(@solr_document['complex_purchase_record_item_tesim']).to match_array(
        ['Item 1', 'Item 2', 'Item 3'])
    end
    it 'indexes purchase record title as stored_searchable' do
      expect(@solr_document['complex_purchase_record_title_tesim']).to match_array(
        ['Purchase record title', 'Purchase record title 2', 'Purchase record title 3'])
    end
    it 'indexes purchase record title as facetable' do
      expect(@solr_document['complex_purchase_record_title_sim']).to match_array(
        ['Purchase record title', 'Purchase record title 2', 'Purchase record title 3'])
    end
    it 'indexes purchase record date as dateable' do
      expect(@solr_document['complex_date_purchased_dtsim']).to match_array(
        ["2018-02-14T00:00:00Z", "2019-02-14T00:00:00Z", "2019-03-14T00:00:00Z"])
    end
    it 'indexes purchase record date as displayable' do
      expect(@solr_document['complex_date_purchased_ssm']).to match_array(
        ['2018-02-14', '2019-02-14', '2019-03-14'])
    end
    it 'indexes purchase record identifier as symbol' do
      expect(@solr_document['complex_purchase_record_identifier_ssim']).to match_array(
        ['purchase_record/12345', 'purchase_record/67890', 'purchase_record/asdfg'])
    end
    it 'indexes purchase record manufacturer as stored_searchable' do
      expect(@solr_document['complex_purchase_record_manufacturer_tesim']).to match_array(
        ['Foo', 'Foo', 'Foo'])
    end
    it 'indexes purchase record manufacturer as facetable' do
      expect(@solr_document['complex_purchase_record_manufacturer_sim']).to match_array(
        ['Foo', 'Foo', 'Foo'])
    end
    it 'indexes purchase record manufacturer sub_organization as stored_searchable' do
      expect(@solr_document['complex_purchase_record_manufacturer_sub_organization_tesim']).to match_array(
        ['Bar', 'Bar', 'Bar 2'])
    end
    it 'indexes purchase record manufacturer as facetable' do
      expect(@solr_document['complex_purchase_record_manufacturer_sub_organization_sim']).to match_array(
        ['Bar', 'Bar', 'Bar 2'])
    end
    it 'indexes purchase record supplier as stored_searchable' do
      expect(@solr_document['complex_purchase_record_supplier_tesim']).to match_array(
        ['Fooss', 'Fooss', 'Fooss'])
    end
    it 'indexes purchase record supplier as facetable' do
      expect(@solr_document['complex_purchase_record_supplier_sim']).to match_array(
        ['Fooss', 'Fooss', 'Fooss'])
    end
    it 'indexes purchase record supplier sub_organization as stored_searchable' do
      expect(@solr_document['complex_purchase_record_supplier_sub_organization_tesim']).to match_array(
        ['Barss', 'Barss', 'Barss 2'])
    end
    it 'indexes purchase record supplier as facetable' do
      expect(@solr_document['complex_purchase_record_supplier_sub_organization_sim']).to match_array(
        ['Barss', 'Barss', 'Barss 2'])
    end
    it 'indexes shape as stored_searchable' do
      expect(@solr_document['complex_shape_tesim']).to match_array(
        ['shape description', 'shape description 2'])
    end
    it 'indexes shape identifier as stored_searchable' do
      expect(@solr_document['complex_shape_identifier_ssim']).to match_array(
        ['shape/12345', 'shape/67890'])
    end
    it 'indexes state_of_matter as stored_searchable' do
      expect(@solr_document['complex_state_of_matter_tesim']).to match_array(
        ['state of matter description', 'state of matter description 2'])
    end
    it 'indexes state_of_matter identifier as stored_searchable' do
      expect(@solr_document['complex_state_of_matter_identifier_ssim']).to match_array(
        ['state/12345', 'state/67890'])
    end
  end

  describe 'indexes synthesis and processing' do
    before do
      obj = build(:dataset, synthesis_and_processing: ['synthesis A'])
      @solr_document = obj.to_solr
    end
    it 'indexes as stored searchable' do
      expect(@solr_document['synthesis_and_processing_tesim']).to match_array(['synthesis A'])
    end
    it 'indexes as facetable' do
      expect(@solr_document['synthesis_and_processing_sim']).to match_array(['synthesis A'])
    end
  end

  describe 'indexes a custom property (additional metadata) active triple resource with all the attributes' do
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
      obj = build(:dataset, complex_event_attributes: events)
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
  end

  describe 'indexes the funding reference active triple resource with all the attributes' do
    before do
      fund_ref = [
        {
          funder_identifier: 'f12345',
          funder_name: 'Bar',
          award_number: 'c232',
          award_uri: 'http://award.com/c232',
          award_title: 'Title of the award'
        },
        {
          funder_identifier: 'f22345',
          funder_name: 'Baz',
          award_number: 'a223345',
          award_uri: 'http://award.com/a223345',
          award_title: 'Another award'
        }
      ]
      obj = build(:dataset, complex_funding_reference_attributes: fund_ref)
      @solr_document = obj.to_solr
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_funding_reference_ssm')
      expect(JSON.parse(@solr_document['complex_funding_reference_ssm'])).not_to be_empty
    end
    it 'indexes funder identifier as symbol' do
      expect(@solr_document['funder_identifier_ssim']).to match_array(['f12345', 'f22345'])
    end
    it 'indexes funder name as stored searchable' do
      expect(@solr_document['funder_tesim']).to match_array(['Bar', 'Baz'])
    end
    it 'indexes funder name as facetable' do
      expect(@solr_document['funder_sim']).to match_array(['Bar', 'Baz'])
    end
    it 'indexes award number as symbol' do
      expect(@solr_document['award_number_ssim']).to match_array(['c232', 'a223345'])
    end
    it 'indexes award title as stored searchable' do
      expect(@solr_document['award_title_tesim']).to match_array(['Title of the award', 'Another award'])
    end
  end

  describe 'indexes the chemical composition active triple resource with all the attributes' do
    before do
      chemical_composition = [
        {
          description: 'chemical composition 1',
          category: 'http://id.example.jp/Q12345',
          complex_identifier_attributes: [{
            identifier: ['chemical_composition/12345']
          }]
        },
        {
          description: 'chemical composition 2',
          category: 'http://id.example.jp/Q67890',
          complex_identifier_attributes: [{
            identifier: ['chemical_composition/67890']
          }]
        }
      ]
      obj = build(:dataset, complex_chemical_composition_attributes: chemical_composition)
      @solr_document = obj.to_solr
    end
    it 'indexes as symbol' do
      expect(@solr_document['complex_chemical_composition_identifier_ssim']).to match_array(["chemical_composition/12345", "chemical_composition/67890"])
      expect(@solr_document['complex_chemical_composition_category_ssim']).to match_array(["http://id.example.jp/Q12345", "http://id.example.jp/Q67890"])
    end
    it 'indexes as displayable' do
      expect(@solr_document).to include('complex_chemical_composition_ssm')
      expect(JSON.parse(@solr_document['complex_chemical_composition_ssm'])).not_to be_empty
    end
    it 'indexes chemical_composition as stored_searchable' do
      expect(@solr_document['complex_chemical_composition_tesim']).to match_array(
        ['chemical composition 1', 'chemical composition 2'])
    end
    it 'indexes chemical_composition identifier as stored_searchable' do
      expect(@solr_document['complex_chemical_composition_identifier_ssim']).to match_array(
        ['chemical_composition/12345', 'chemical_composition/67890']
      )
    end
    it 'indexes chemical_composition identifier as facetable' do
      expect(@solr_document['complex_chemical_composition_identifier_sim']).to match_array(
        ['chemical_composition/12345', 'chemical_composition/67890']
      )
    end
  end

  describe 'indexes the structural feature active triple resource with all the attributes' do
    before do
      structural_feature = [{
        description: 'structural feature description',
        category: 'structural feature category',
        sub_category: 'structural feature sub category',
        complex_identifier_attributes: [{
          identifier: ['structural_feature/12345'],
          label: ['Local']
        }]
      },
      {
        description: 'structural feature description 2',
        category: 'structural feature category 2',
        sub_category: 'structural feature sub category',
        complex_identifier_attributes: [{
          identifier: ['structural_feature/67890'],
          label: ['Local']
        }]
      }]
      obj = build(:dataset, complex_structural_feature_attributes: structural_feature)
      @solr_document = obj.to_solr
    end

    it 'indexes structural feature category as stored_searchable' do
      expect(@solr_document['complex_structural_feature_category_tesim']).to match_array(
        ['structural feature category', 'structural feature category 2'])
    end
    it 'indexes structural feature category as facetable' do
      expect(@solr_document['complex_structural_feature_category_sim']).to match_array(
        ['structural feature category', 'structural feature category 2'])
    end
    it 'indexes structural feature description as stored_searchable' do
      expect(@solr_document['complex_structural_feature_description_tesim']).to match_array(
        ['structural feature description', 'structural feature description 2'])
    end
    it 'indexes structural feature sub category as stored_searchable' do
      expect(@solr_document['complex_structural_feature_sub_category_tesim']).to match_array(
        ['structural feature sub category', 'structural feature sub category'])
    end
    it 'indexes structural feature identifier as symbol' do
      expect(@solr_document['complex_structural_feature_identifier_ssim']).to match_array(
        ['structural_feature/12345', 'structural_feature/67890'])
    end
  end

  describe 'indexes the crystallographic_structure active triple resource with all the attributes' do
    before do
      crystallographic_structure = [
        {
          description: 'crystallographic_structure description 1',
          specimen_identifier: 'sample10',
          category_vocabulary: 'http://vocabulary.example.jp/Q234',
          category_description: 'Q234'
        },
        {
          description: 'crystallographic_structure description 2',
          specimen_identifier: 'sample20',
          category_vocabulary: 'http://vocabulary.example.jp/Q235',
          category_description: 'Q235'
        }
      ]
      obj = build(:dataset, complex_crystallographic_structure_attributes: crystallographic_structure)
      @solr_document = obj.to_solr
    end

    it 'indexes crystallographic_structure name as stored_searchable' do
      expect(@solr_document['complex_crystallographic_structure_description_tesim']).to match_array(
        ['crystallographic_structure description 1', 'crystallographic_structure description 2'])
    end
    it 'indexes crystallographic_structure category_vocabulary as facetable' do
      expect(@solr_document['complex_crystallographic_structure_category_vocabulary_sim']).to match_array(
        ['http://vocabulary.example.jp/Q234', 'http://vocabulary.example.jp/Q235'])
    end
    it 'indexes crystallographic_structure description as stored_searchable' do
      expect(@solr_document['complex_crystallographic_structure_description_tesim']).to match_array(
        ['crystallographic_structure description 1', 'crystallographic_structure description 2'])
    end
    it 'indexes crystallographic_structure specimen_identifier as symbol' do
      expect(@solr_document['complex_crystallographic_structure_specimen_identifier_ssim']).to match_array(
        ['sample10', 'sample20'])
    end
  end

  describe 'indexes the feature active triple resource with all the attributes' do
    before do
      feature = [
        {
          description: 'feature 1',
          category_vocabulary: 'http://vocabulary.example.jp/Q234',
          unit_vocabulary: 'http://vocabulary.example.jp/Q235',
          value: '100'
        },
        {
          description: 'feature 2',
          category_vocabulary: 'http://vocabulary.example.jp/Q236',
          unit_vocabulary: 'http://vocabulary.example.jp/Q237',
          value: '200'
        }
      ]
      obj = build(:dataset, complex_feature_attributes: feature)
      @solr_document = obj.to_solr
    end

    it 'indexes feature description as stored_searchable' do
      expect(@solr_document['complex_feature_description_tesim']).to match_array(
        ['feature 1', 'feature 2'])
    end
    it 'indexes feature category_vocabulary as facetable' do
      expect(@solr_document['complex_feature_category_vocabulary_sim']).to match_array(
        ['http://vocabulary.example.jp/Q234', 'http://vocabulary.example.jp/Q236'])
    end
    it 'indexes feature unit_vocabulary as facetable' do
      expect(@solr_document['complex_feature_unit_vocabulary_sim']).to match_array(
        ['http://vocabulary.example.jp/Q235', 'http://vocabulary.example.jp/Q237'])
    end
    it 'indexes feature description as stored_searchable' do
      expect(@solr_document['complex_feature_description_tesim']).to match_array(
        ['feature 1', 'feature 2'])
    end
  end

  describe 'indexes the software active triple resource with all the attributes' do
    before do
      software = [
        {
          description: 'software description 1',
          version: '1.0',
          identifier: 'sample10',
          name: 'sample1.exe',
        },
        {
          description: 'software description 2',
          version: '2.0',
          identifier: 'sample20',
          name: 'sample2.exe'
        }
      ]
      obj = build(:dataset, complex_software_attributes: software)
      @solr_document = obj.to_solr
    end

    it 'indexes software name as stored_searchable' do
      expect(@solr_document['complex_software_name_tesim']).to match_array(
        ['sample1.exe', 'sample2.exe'])
    end
    it 'indexes software name as facetable' do
      expect(@solr_document['complex_software_name_sim']).to match_array(
        ['sample1.exe', 'sample2.exe'])
    end
    it 'indexes software description as stored_searchable' do
      expect(@solr_document['complex_software_description_tesim']).to match_array(
        ['software description 1', 'software description 2'])
    end
    it 'indexes software identifier as symbol' do
      expect(@solr_document['complex_software_identifier_ssim']).to match_array(
        ['sample10', 'sample20'])
    end
  end

  describe 'indexes the computational method active triple resource with all the attributes' do
    before do
      computational_method = [
        {
          description: 'computational method 1',
          category_vocabulary: 'http://vocabulary.example.jp/Q234',
          category_description: 'Q234',
          calculated_at: '2023-01-01 00:00:00'
        },
        {
          description: 'computational method 2',
          category_vocabulary: 'http://vocabulary.example.jp/Q235',
          category_description: 'Q235',
          calculated_at: '2023-01-01 00:01:00'
        }
      ]
      obj = build(:dataset, complex_computational_method_attributes: computational_method)
      @solr_document = obj.to_solr
    end

    it 'indexes computational method description as stored_searchable' do
      expect(@solr_document['complex_computational_method_description_tesim']).to match_array(
        ['computational method 1', 'computational method 2'])
    end
    it 'indexes feature category_vocabulary as facetable' do
      expect(@solr_document['complex_computational_method_category_vocabulary_sim']).to match_array(
        ['http://vocabulary.example.jp/Q234', 'http://vocabulary.example.jp/Q235'])
    end
  end

  describe 'indexes the experimental method active triple resource with all the attributes' do
    before do
      experimental_method = [
        {
          description: 'experimental method 1',
          category_vocabulary: 'http://vocabulary.example.jp/Q345',
          category_description: 'Q345',
          analysis_field_vocabulary: 'http://vocabulary.example.jp/Q4561',
          analysis_field_description: 'Category Q4561',
          measurement_environment_vocabulary: 'http://vocabulary.example.jp/Q4562',
          standarized_procedure_vocabulary: 'http://vocabulary.example.jp/Q4563',
          measured_at: '2023-01-01 00:02:00'
        },
        {
          description: 'experimental method 2',
          category_vocabulary: 'http://vocabulary.example.jp/Q346',
          category_description: 'Q346',
          analysis_field_vocabulary: 'http://vocabulary.example.jp/Q4564',
          analysis_field_description: 'Category Q4564',
          measurement_environment_vocabulary: 'http://vocabulary.example.jp/Q4565',
          standarized_procedure_vocabulary: 'http://vocabulary.example.jp/Q4566',
          measured_at: '2023-01-01 00:03:00'
        }
      ]
      obj = build(:dataset, complex_experimental_method_attributes: experimental_method)
      @solr_document = obj.to_solr
    end

    it 'indexes experimental method description as stored_searchable' do
      expect(@solr_document['complex_experimental_method_description_tesim']).to match_array(
        ['experimental method 1', 'experimental method 2'])
    end
    it 'indexes feature category_vocabulary as facetable' do
      expect(@solr_document['complex_experimental_method_category_vocabulary_sim']).to match_array(
        ['http://vocabulary.example.jp/Q345', 'http://vocabulary.example.jp/Q346'])
    end
  end

  describe 'facet fields' do
    it 'to not index specimen_set_tesim' do
      expect(described_class.facet_fields).not_to include('specimen_set_tesim')
    end
  end
end
