# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Dataset do
  it 'has human readable type for the dataset' do
    @obj = build(:dataset)
    expect(@obj.human_readable_type).to eq('Dataset')
  end

  describe 'date_modified' do
    it 'has date_modified as singular' do
      @obj = build(:dataset, date_modified: '2018/04/23')
      expect(@obj.date_modified).to eq '2018/04/23'
    end
  end

  describe 'date_uploaded' do
    it 'has date_uploaded as singular' do
      @obj = build(:dataset, date_uploaded: '2018 01 02')
      expect(@obj.date_uploaded).to eq '2018 01 02'
    end
  end

  describe 'depositor' do
    it 'has depositor' do
      @obj = build(:dataset, depositor: 'Name of depositor')
      expect(@obj.depositor).to eq 'Name of depositor'
    end
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:dataset, title: nil)
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid, 'Validation failed: Title Your dataset must have a title.')
    end

    it 'has a multi valued title field' do
      @obj = build(:dataset, title: ['test dataset'])
      expect(@obj.title).to eq ['test dataset']
    end
  end

  describe 'based_near' do
    it 'has based_near' do
      @obj = build(:dataset, based_near: ['me'])
      expect(@obj.based_near).to eq ['me']
    end
  end

  describe 'bibliographic_citation' do
    it 'has bibliographic_citation' do
      @obj = build(:dataset, bibliographic_citation: ['bibliographic_citation 1'])
      expect(@obj.bibliographic_citation).to eq ['bibliographic_citation 1']
    end
  end

  describe 'contributor' do
    it 'has contributor' do
      @obj = build(:dataset, contributor: ['contributor 1'])
      expect(@obj.contributor).to eq ['contributor 1']
    end
  end

  describe 'creator' do
    it 'has creator' do
      @obj = build(:dataset, creator: ['Creator 1'])
      expect(@obj.creator).to eq ['Creator 1']
    end
  end

  describe 'date_created' do
    it 'has date_created' do
      @obj = build(:dataset, date_created: ['date_created 1'])
      expect(@obj.date_created).to eq ['date_created 1']
    end
  end

  describe 'description' do
    it 'has description' do
      @obj = build(:dataset, description: ['description 1'])
      expect(@obj.description).to eq ['description 1']
    end
  end

  describe 'identifier' do
    it 'has identifier' do
      @obj = build(:dataset, identifier: ['identifier 1'])
      expect(@obj.identifier).to eq ['identifier 1']
    end
  end

  describe 'import_url' do
    it 'has import_url as singular' do
      @obj = build(:dataset, import_url: 'http://example.com/import/url')
      expect(@obj.import_url).to eq 'http://example.com/import/url'
    end
  end

  describe 'keyword' do
    it 'has keyword' do
      @obj = build(:dataset, keyword: ['keyword 1', 'keyword 2'])
      expect(@obj.keyword).to eq ['keyword 1', 'keyword 2']
    end
  end

  describe 'label' do
    it 'has label as singular' do
      @obj = build(:dataset, label: 'Label 1')
      expect(@obj.label).to eq 'Label 1'
    end
  end

  describe 'language' do
    it 'has language' do
      @obj = build(:dataset, language: ['language 1'])
      expect(@obj.language).to eq ['language 1']
    end
  end

  describe 'part_of' do
    it 'has part_of' do
      skip 'Not using this field. Raises RSolr::Error::ConnectionRefused when added to index.'
      @obj = build(:dataset, part_of: ['Bigger dataset'])
      expect(@obj.part_of).to eq ['Bigger dataset']
    end
  end

  describe 'publisher' do
    it 'has publisher' do
      @obj = build(:dataset, publisher: ['publisher 1'])
      expect(@obj.publisher).to eq ['publisher 1']
    end
  end

  describe 'related_url' do
    it 'has related_url' do
      @obj = build(:dataset, related_url: ['http://example.com/related/url'])
      expect(@obj.related_url).to eq ['http://example.com/related/url']
    end
  end

  describe 'relative_path' do
    it 'has relative_path as singular' do
      @obj = build(:dataset, relative_path: 'relative/path/to/file')
      expect(@obj.relative_path).to eq 'relative/path/to/file'
    end
  end

  describe 'resource_type' do
    it 'has resource_type' do
      @obj = build(:dataset, resource_type: ['Dataset'])
      expect(@obj.resource_type).to eq ['Dataset']
    end
  end

  describe 'rights or license' do
    it 'has license (saved as dct:rights)' do
      @obj = build(:dataset, license: ['CC-0'])
      expect(@obj.license).to eq ['CC-0']
    end
  end

  describe 'complex_rights' do
    it 'creates a complex rights active triple resource with rights' do
      @obj = build(:dataset, complex_rights_attributes: [{
          rights: 'cc0'
        }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.id).to include('#rights')
      expect(@obj.complex_rights.first.rights).to eq ['cc0']
      expect(@obj.complex_rights.first.date).to be_empty
    end

    it 'creates a rights active triple resource with all the attributes' do
      @obj = build(:dataset, complex_rights_attributes: [{
          date: '1978-10-28',
          rights: 'CC0'
        }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.date).to eq ['1978-10-28']
      expect(@obj.complex_rights.first.rights).to eq ['CC0']
    end

    it 'rejects a rights active triple with no rights' do
      @obj = build(:dataset, complex_rights_attributes: [{
          date: '2018-01-01'
        }]
      )
      expect(@obj.complex_rights).to be_empty
    end
  end

  describe 'rights_statement' do
    it 'has rights_statement' do
      @obj = build(:dataset, rights_statement: ['rights_statement 1'])
      expect(@obj.rights_statement).to eq ['rights_statement 1']
    end
  end

  describe 'source' do
    it 'has source' do
      @obj = build(:dataset, source: ['Source 1'])
      expect(@obj.source).to eq ['Source 1']
    end
  end

  describe 'subject' do
    it 'has subject' do
      @obj = build(:dataset, subject: ['subject 1'])
      expect(@obj.subject).to eq ['subject 1']
    end
  end

  describe 'alternative_title' do
    it 'has alternative_title as singular' do
      @obj = build(:dataset, alternative_title: 'Alternative Title')
      expect(@obj.alternative_title).to eq 'Alternative Title'
    end
  end

  describe 'complex_date' do
    it 'creates a date active triple resource with all the attributes' do
      @obj = build(:dataset, complex_date_attributes: [
          {
            date: '1978-10-28',
            description: 'Some kind of a date',
          }
        ]
      )
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1978-10-28']
      expect(@obj.complex_date.first.description).to eq ['Some kind of a date']
    end

    it 'creates a date active triple resource with just the date' do
      @obj = build(:dataset, complex_date_attributes: [
          {
            date: '1984-09-01'
          }
        ]
      )
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no date' do
      @obj = build(:dataset, complex_date_attributes: [
          {
            description: 'Local date'
          }
        ]
      )
      expect(@obj.complex_date).to be_empty
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:dataset, complex_identifier_attributes: [{
          identifier: '0000-0000-0000-0000',
          scheme: 'uri_of_ORCID_scheme',
          label: 'ORCID'
        }]
      )
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['0000-0000-0000-0000']
      expect(@obj.complex_identifier.first.scheme).to eq ['uri_of_ORCID_scheme']
      expect(@obj.complex_identifier.first.label).to eq ['ORCID']
    end

    it 'creates an identifier active triple resource with just the identifier' do
      @obj = build(:dataset, complex_identifier_attributes: [{
          identifier: '1234'
        }]
      )
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no identifier' do
      @obj = build(:dataset, complex_identifier_attributes: [{
          label: 'Local'
        }]
      )
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'complex_person' do
    it 'creates a person active triple resource with name' do
      @obj = build(:dataset, complex_person_attributes: [{
          name: 'Anamika'
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with name, affiliation and role' do
      @obj = build(:dataset, complex_person_attributes: [{
          name: 'Anamika',
          affiliation: 'Paradise',
          role: 'Creator'
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.affiliation).to eq ['Paradise']
      expect(@obj.complex_person.first.role).to eq ['Creator']
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'rejects person active triple with no name and only uri' do
      @obj = build(:dataset, complex_person_attributes: [{
          uri: 'http://example.com/person/123456'
        }]
      )
      expect(@obj.complex_person).to be_empty
    end
  end

  describe 'complex_version' do
    it 'creates a version active triple resource with all the attributes' do
      @obj = build(:dataset, complex_version_attributes: [{
          date: '1978-10-28',
          description: 'Creating the first version',
          identifier: 'id1',
          version: '1.0'
        }]
      )
      expect(@obj.complex_version.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_version.first.id).to include('#version')
      expect(@obj.complex_version.first.date).to eq ['1978-10-28']
      expect(@obj.complex_version.first.description).to eq ['Creating the first version']
      expect(@obj.complex_version.first.identifier).to eq ['id1']
      expect(@obj.complex_version.first.version).to eq ['1.0']
    end

    it 'creates a version active triple resource with just the version' do
      @obj = build(:dataset, complex_version_attributes: [{
          version: '1.0'
        }]
      )
      expect(@obj.complex_version.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_version.first.id).to include('#version')
      expect(@obj.complex_version.first.version).to eq ['1.0']
      expect(@obj.complex_version.first.date).to be_empty
      expect(@obj.complex_version.first.description).to be_empty
      expect(@obj.complex_version.first.identifier).to be_empty
    end

    it 'rejects a version active triple with no version' do
      @obj = build(:dataset, complex_version_attributes: [{
          description: 'Local version',
          identifier: 'id1',
          date: '2018-01-01'
        }]
      )
      expect(@obj.complex_version).to be_empty
    end
  end

  describe 'characterization_methods' do
    it 'has characterization_methods' do
      @obj = build(:dataset, characterization_methods: 'Characterization methods')
      expect(@obj.characterization_methods).to eq 'Characterization methods'
    end
  end

  describe 'computational_methods' do
    it 'has computational_methods' do
      @obj = build(:dataset, computational_methods: 'computational methods')
      expect(@obj.computational_methods).to eq 'computational methods'
    end
  end

  describe 'data_origin' do
    it 'has data_origin' do
      @obj = build(:dataset, data_origin: ['data origin'])
      expect(@obj.data_origin).to eq ['data origin']
    end
  end

  describe 'instrument' do
    it 'creates an instrument active triple resource with all the attributes' do
      @obj = build(:dataset, instrument_attributes: [{
          alternative_title: 'An instrument title',
          complex_date_attributes: [{
            date: ['2018-02-14']
          }],
          description: 'Instrument description',
          complex_identifier_attributes: [{
            identifier: ['123456'],
            label: ['Local']
          }],
          function_1: ['Has a function'],
          function_2: ['Has two functions'],
          manufacturer: 'Manufacturer name',
          complex_person_attributes: [{
            name: ['Name of operator'],
            role: ['Operator']
          }],
          organization: 'Organisation',
          title: 'Instrument title'
        }]
      )
      expect(@obj.instrument.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.id).to include('#instrument')
      expect(@obj.instrument.first.alternative_title).to eq ['An instrument title']
      expect(@obj.instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_date.first.date).to eq ['2018-02-14']
      expect(@obj.instrument.first.description).to eq ['Instrument description']
      expect(@obj.instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.instrument.first.complex_identifier.first.label).to eq ['Local']
      expect(@obj.instrument.first.function_1).to eq ['Has a function']
      expect(@obj.instrument.first.function_2).to eq ['Has two functions']
      expect(@obj.instrument.first.manufacturer).to eq ['Manufacturer name']
      expect(@obj.instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_person.first.name).to eq ['Name of operator']
      expect(@obj.instrument.first.complex_person.first.role).to eq ['Operator']
      expect(@obj.instrument.first.organization).to eq ['Organisation']
      expect(@obj.instrument.first.title).to eq ['Instrument title']
    end

    it 'creates an instrument active triple resource with date, identifier and person' do
      @obj = build(:dataset, instrument_attributes: [{
          complex_date_attributes: [{
            date: ['2018-01-28'],
          }],
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }],
          complex_person_attributes: [{
            name: ['operator 1'],
            role: ['Operator']
          }]
        }]
      )
      expect(@obj.instrument.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_date.first.date).to eq ['2018-01-28']
      expect(@obj.instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.instrument.first.complex_person.first.name).to eq ['operator 1']
      expect(@obj.instrument.first.complex_person.first.role).to eq ['Operator']
    end

    it 'rejects an instrument active triple with no date, identifier and person' do
      @obj = build(:dataset, instrument_attributes: [{
          title: 'Instrument A',
        }]
      )
      expect(@obj.instrument).to be_empty
    end
  end

  describe 'origin_system_provenance' do
    it 'has origin_system_provenance' do
      @obj = build(:dataset, origin_system_provenance: 'origin system provenance')
      expect(@obj.origin_system_provenance).to eq 'origin system provenance'
    end
  end

  describe 'properties_addressed' do
    it 'has properties_addressed' do
      @obj = build(:dataset, properties_addressed: ['properties addressed'])
      expect(@obj.properties_addressed).to eq ['properties addressed']
    end
  end

  describe 'complex_relation' do
    it 'creates a relation active triple resource with all the attributes' do
      @obj = build(:dataset, complex_relation_attributes: [
        {
          title: 'A related item',
          url: 'http://example.com/relation',
          complex_identifier_attributes: [{
            identifier: ['123456'],
            label: ['local']
          }],
          relationship: 'IsPartOf'
        }]
      )
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A related item']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['local']
      expect(@obj.complex_relation.first.relationship).to eq ['IsPartOf']
    end

    it 'creates a relation active triple resource with title, url, identifier and relationship role' do
      @obj = build(:dataset, complex_relation_attributes: [{
          title: 'A relation label',
          url: 'http://example.com/relation',
          complex_identifier_attributes: [{
            identifier: ['123456']
          }],
          relationship: 'isNewVersionOf'
        }]
      )
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['isNewVersionOf']
    end

    it 'rejects relation active triple with url' do
      @obj = build(:dataset, complex_relation_attributes: [{
          url: 'http://example.com/relation'
        }]
      )
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with identifier' do
      @obj = build(:dataset, complex_relation_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['123456'],
            label: 'Local'
          }],
        }]
      )
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with reltionship name' do
      @obj = build(:dataset, complex_relation_attributes: [{
          relationship: 'isPartOf'
        }]
      )
      expect(@obj.complex_relation).to be_empty
    end
  end

  describe 'specimen_set' do
    it 'has specimen_set' do
      @obj = build(:dataset, specimen_set: 'Specimen set')
      expect(@obj.specimen_set).to eq 'Specimen set'
    end
  end

  describe 'specimen_type' do
    it 'creates a specimen type active triple resource with all the attributes' do
      @obj = build(:dataset, specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystallographic_structure: 'crystallographic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          purchase_record_attributes: [{
            date: '2018-09-23',
            title: 'Purchase record 1'
          }],
          complex_relation_attributes: [{
            url: 'http://example.com/relation',
            relationship: 'isPartOf'
          }],
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      )
      expect(@obj.specimen_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.id).to include('#specimen')
      expect(@obj.specimen_type.first.chemical_composition).to eq ['chemical composition']
      expect(@obj.specimen_type.first.crystallographic_structure).to eq ['crystallographic structure']
      expect(@obj.specimen_type.first.description).to eq ['Description']
      expect(@obj.specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.specimen_type.first.material_types).to eq ['material types']
      expect(@obj.specimen_type.first.purchase_record.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.purchase_record.first.date).to eq ['2018-09-23']
      expect(@obj.specimen_type.first.purchase_record.first.title).to eq ['Purchase record 1']
      expect(@obj.specimen_type.first.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.specimen_type.first.complex_relation.first.relationship).to eq ['isPartOf']
      expect(@obj.specimen_type.first.structural_features).to eq ['structural features']
      expect(@obj.specimen_type.first.title).to eq ['Instrument 1']
    end

    it 'creates a specimen type active triple resource with the 7 required attributes' do
      @obj = build(:dataset, specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystallographic_structure: 'crystallographic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      )
      expect(@obj.specimen_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.chemical_composition).to eq ['chemical composition']
      expect(@obj.specimen_type.first.crystallographic_structure).to eq ['crystallographic structure']
      expect(@obj.specimen_type.first.description).to eq ['Description']
      expect(@obj.specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.specimen_type.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.specimen_type.first.material_types).to eq ['material types']
      expect(@obj.specimen_type.first.structural_features).to eq ['structural features']
      expect(@obj.specimen_type.first.title).to eq ['Instrument 1']
    end

    it 'rejects a specimen type active triple with no identifier' do
      @obj = build(:dataset, specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystallographic_structure: 'crystallographic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            label: 'ORCID'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      )
      expect(@obj.specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with only purchase record and relation' do
      @obj = build(:dataset, specimen_type_attributes: [{
          purchase_record_attributes: [{
            date: '2018-09-23',
            title: 'Purchase record 1'
          }],
          complex_relation_attributes: [{
            url: 'http://example.com/relation',
            relationship: 'isPartOf'
          }]
        }]
      )
      expect(@obj.specimen_type).to be_empty
    end
  end

  describe 'synthesis_and_processing' do
    it 'has synthesis_and_processing' do
      @obj = build(:dataset, synthesis_and_processing: 'Synthesis and processing methods')
      expect(@obj.synthesis_and_processing).to eq 'Synthesis and processing methods'
    end
  end

  describe 'custom_property' do
    it 'creates a custom property active triple resource with all the attributes' do
      @obj = build(:dataset, custom_property_attributes: [{
          label: 'Full name',
          description: 'My full name is ...'
        }]
      )
      expect(@obj.custom_property.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.custom_property.first.id).to include('#key_value')
      expect(@obj.custom_property.first.label).to eq ['Full name']
      expect(@obj.custom_property.first.description).to eq ['My full name is ...']
    end

    it 'rejects a custom property active triple with no label' do
      @obj = build(:dataset, custom_property_attributes: [{
          description: 'Local date'
        }]
      )
      expect(@obj.custom_property).to be_empty
    end

    it 'rejects a custom property active triple with no description' do
      @obj = build(:dataset, custom_property_attributes: [{
          label: 'Local date'
        }]
      )
      expect(@obj.custom_property).to be_empty
    end
  end
end
