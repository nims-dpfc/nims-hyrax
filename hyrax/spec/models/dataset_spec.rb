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

  ##
  # Is this work in a draft state?
  describe '#draft?' do
    it 'is false if the draft field is blank' do
      @obj = build(:dataset)
      expect(@obj.draft?).to eq false
    end
    it "is true if the draft field is true" do
      @obj = build(:dataset)
      @obj.draft = ['true']
      expect(@obj.draft?).to eq true
    end
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:dataset, title: nil)
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid,
        'Validation failed: Title Your dataset must have a title.')
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
      @obj = build(:dataset, keyword: ['keyword 2', '3 keyword', 'keyword 1'])
      expect(@obj.keyword).to eq ['keyword 2', '3 keyword', 'keyword 1']
    end

    it 'preserves keyword order' do
      @obj = Dataset.create(attributes_for(:dataset, keyword_ordered: ['keyword 2', '3 keyword', 'keyword 1']))
      after = Dataset.find(@obj.id)
      expect(after.keyword).to match_array ['0 ~ keyword 2', '1 ~ 3 keyword', '2 ~ keyword 1']
      expect(after.keyword_ordered).to eq ['keyword 2', '3 keyword', 'keyword 1']

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

  describe 'supervisor_approval' do
    it 'has supervisor_approval' do
      @obj = build(:dataset, supervisor_approval: ['Kosuke Tanabe 2019.08.01'])
      expect(@obj.supervisor_approval).to eq ['Kosuke Tanabe 2019.08.01']
    end
  end

  describe 'complex_rights' do
    it 'creates a complex rights active triple resource with rights' do
      @obj = build(:dataset,
        complex_rights_attributes: [{
          rights: 'cc0'
        }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.id).to include('#rights')
      expect(@obj.complex_rights.first.rights).to eq ['cc0']
      expect(@obj.complex_rights.first.date).to be_empty
    end

    it 'creates a rights active triple resource with all the attributes' do
      @obj = build(:dataset,
        complex_rights_attributes: [{
          date: '1978-10-28',
          rights: 'CC0'
        }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.date).to eq ['1978-10-28']
      expect(@obj.complex_rights.first.rights).to eq ['CC0']
    end

    it 'rejects a rights active triple with no rights' do
      @obj = build(:dataset,
        complex_rights_attributes: [{
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
      @obj = build(:dataset,
        complex_date_attributes: [{
          date: '1978-10-28',
          description: 'Some kind of a date',
        }]
      )
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1978-10-28']
      expect(@obj.complex_date.first.description).to eq ['Some kind of a date']
    end

    it 'creates a date active triple resource with just the date' do
      @obj = build(:dataset,
        complex_date_attributes: [{
          date: '1984-09-01'
        }]
      )
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no date' do
      @obj = build(:dataset,
        complex_date_attributes: [{
          description: 'Local date'
        }]
      )
      expect(@obj.complex_date).to be_empty
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:dataset,
        complex_identifier_attributes: [{
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
      @obj = build(:dataset,
        complex_identifier_attributes: [{
          identifier: '1234'
        }]
      )
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no identifier' do
      @obj = build(:dataset,
        complex_identifier_attributes: [{
          label: 'Local'
        }]
      )
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'complex_person' do
    it 'creates a person active triple resource with name' do
      @obj = build(:dataset,
        complex_person_attributes: [{
          name: 'Anamika'
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.email).to be_empty
      expect(@obj.complex_person.first.complex_affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.display_order).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with name, affiliation and role' do
      @obj = build(:dataset,
        complex_person_attributes: [{
          name: 'Anamika',
          complex_affiliation_attributes: [{
            job_title: 'Paradise',
          }],
          role: 'Creator',
          display_order: 1
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.email).to be_empty
      expect(@obj.complex_person.first.role).to eq ['Creator']
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.display_order).to eq([1])
      expect(@obj.complex_person.first.uri).to be_empty
      expect(@obj.complex_person.first.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.complex_affiliation.first.job_title).to eq ['Paradise']
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

  describe 'complex_organization' do
    it 'creates an organization active triple resource with an id and all properties' do
      @obj = build(:dataset, complex_organization_attributes: [{
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'org purpose',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }]
        }]
      )
      expect(@obj.complex_organization.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_organization.first.id).to include('#organization')
      expect(@obj.complex_organization.first.organization).to eq ['Foo']
      expect(@obj.complex_organization.first.sub_organization).to eq ['Bar']
      expect(@obj.complex_organization.first.purpose).to eq ['org purpose']
      expect(@obj.complex_organization.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.complex_organization.first.complex_identifier.first.scheme).to eq ['Local']
    end

    it 'creates an organization active triple with organization' do
      @obj = build(:dataset, complex_organization_attributes: [{
          organization: 'Foo'
        }]
      )
      expect(@obj.complex_organization.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_organization.first.organization).to eq ['Foo']
      expect(@obj.complex_organization.first.sub_organization).to be_empty
      expect(@obj.complex_organization.first.purpose).to be_empty
      expect(@obj.complex_organization.first.complex_identifier).to be_empty
    end

    it 'rejects an organization active triple with no organization' do
      @obj = build(:dataset, complex_organization_attributes: [{
          sub_organization: 'sub org'
        }]
      )
      expect(@obj.complex_organization).to be_empty
    end
  end

  describe 'characterization_methods' do
    it 'has characterization_methods' do
      @obj = build(:dataset, characterization_methods: ['Characterization methods'])
      expect(@obj.characterization_methods).to eq ['Characterization methods']
    end
  end

  describe 'computational_methods' do
    it 'has computational_methods' do
      @obj = build(:dataset, computational_methods: ['computational methods'])
      expect(@obj.computational_methods).to eq ['computational methods']
    end
  end

  describe 'data_origin' do
    it 'has data_origin' do
      @obj = build(:dataset, data_origin: ['data origin'])
      expect(@obj.data_origin).to eq ['data origin']
    end
  end

  describe 'complex_instrument' do
    it 'creates an instrument active triple resource with all the attributes' do
      @obj = build(:dataset, :with_complex_instrument)
      expect(@obj.complex_instrument.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.alternative_title).to eq ['An instrument title']
      expect(@obj.complex_instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_date.first.date).to eq ['2018-02-14']
      expect(@obj.complex_instrument.first.description).to eq ['Instrument description']
      expect(@obj.complex_instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_identifier.first.identifier).to eq ['instrument/27213727']
      expect(@obj.complex_instrument.first.complex_identifier.first.label).to eq ['Identifier Persistent']
      expect(@obj.complex_instrument.first.complex_identifier.first.scheme).to eq ['identifier persistent']
      expect(@obj.complex_instrument.first.instrument_function.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.instrument_function.first.column_number).to eq [1]
      expect(@obj.complex_instrument.first.instrument_function.first.category).to eq ['some value']
      expect(@obj.complex_instrument.first.instrument_function.first.sub_category).to eq ['some other value']
      expect(@obj.complex_instrument.first.instrument_function.first.description).to eq ['Instrument function description']
      expect(@obj.complex_instrument.first.manufacturer.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.manufacturer.first.organization).to eq ['Foo']
      expect(@obj.complex_instrument.first.manufacturer.first.sub_organization).to eq ['Bar']
      expect(@obj.complex_instrument.first.manufacturer.first.purpose).to eq ['Manufacturer']
      expect(@obj.complex_instrument.first.manufacturer.first.complex_identifier.first.identifier).to eq ['123456789m']
      expect(@obj.complex_instrument.first.manufacturer.first.complex_identifier.first.scheme).to eq ['Local']
      expect(@obj.complex_instrument.first.model_number).to eq ['123xfty']
      expect(@obj.complex_instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_person.first.name).to eq ['Name of operator']
      expect(@obj.complex_instrument.first.complex_person.first.role).to eq ['operator']
      expect(@obj.complex_instrument.first.managing_organization.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.managing_organization.first.organization).to eq ['Managing organization name']
      expect(@obj.complex_instrument.first.managing_organization.first.sub_organization).to eq ['BarBar']
      expect(@obj.complex_instrument.first.managing_organization.first.purpose).to eq ['Managing organization']
      expect(@obj.complex_instrument.first.managing_organization.first.complex_identifier.first.identifier).to eq ['123456789mo']
      expect(@obj.complex_instrument.first.managing_organization.first.complex_identifier.first.scheme).to eq ['Local']
      expect(@obj.complex_instrument.first.title).to eq ['Instrument title']
    end

    it 'creates an complex_instrument active triple resource with date, identifier and person' do
      skip
      @obj = build(:dataset,
        complex_instrument_attributes: [{
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
      expect(@obj.complex_instrument.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_date.first.date).to eq ['2018-01-28']
      expect(@obj.complex_instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_person.first.name).to eq ['operator 1']
      expect(@obj.complex_instrument.first.complex_person.first.role).to eq ['Operator']
    end

    it 'rejects an complex_instrument active triple with no date, identifier and person' do
      skip
      @obj = build(:dataset, complex_instrument_attributes: [{
          title: 'Instrument A',
        }]
      )
      expect(@obj.complex_instrument).to be_empty
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
      @obj = build(:dataset,
        complex_relation_attributes: [{
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
      @obj = build(:dataset,
        complex_relation_attributes: [{
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
      @obj = build(:dataset,
        complex_relation_attributes: [{
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
      @obj = build(:dataset, specimen_set: ['Specimen'])
      expect(@obj.specimen_set).to eq ['Specimen']
    end
  end

  describe 'specimen_type' do
    it 'creates a specimen type active triple resource with all the attributes' do
      @obj = build(:dataset, :with_complex_specimen_type)
      expect(@obj.complex_specimen_type.first).to be_kind_of ActiveTriples::Resource
      # chemical composition
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first.identifier).to eq ['chemical_composition/1234567']
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first.label).to eq ['Identifier - Persistent']
      # crystallographic structure
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first.identifier).to eq ['crystallographic_structure/123456']
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first.label).to eq ['Local']
      # description
      expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
      # identifier
      expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
      expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
      # material type
      expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
      expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to eq ['material description']
      expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to eq ['some material type']
      expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to eq ['some other material sub type']
      expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first.identifier).to eq ['material/ewfqwefqwef']
      expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first.label).to eq ['Identifier - Persistent']
      # purchase record
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.id).to include('#purchase_record')
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.date).to eq ['2018-02-14']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first.identifier).to eq ['purchase_record/123456']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first.label).to eq ['Identifier - Persistent']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.organization).to eq ['Fooss']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.sub_organization).to eq ['Barss']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.purpose).to eq ['Supplier']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.complex_identifier.first.identifier).to eq ['supplier/123456789']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.complex_identifier.first.scheme).to eq ['Local']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.organization).to eq ['Foo']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.sub_organization).to eq ['Bar']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.purpose).to eq ['Manufacturer']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.complex_identifier.first.identifier).to eq ['manufacturer/123456789']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.complex_identifier.first.scheme).to eq ['Local']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.purchase_record_item).to eq ['Has a purchase record item']
      expect(@obj.complex_specimen_type.first.complex_purchase_record.first.title).to eq ['Purchase record title']
      # shape
      expect(@obj.complex_specimen_type.first.complex_shape.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_shape.first.id).to include('#shape')
      expect(@obj.complex_specimen_type.first.complex_shape.first.description).to eq ['shape description']
      expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first.identifier).to eq ['shape/123456']
      expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first.label).to eq ['Identifier - Persistent']
      # state of matter
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.id).to include('#state_of_matter')
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.description).to eq ['state of matter description']
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first.identifier).to eq ['state/123456']
      expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first.label).to eq ["Identifier - Persistent"]
      # structural feature
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to eq ['structural feature description']
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to eq ['structural feature category']
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to eq ['structural feature sub category']
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first.identifier).to eq ['structural_feature/123456']
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first.label).to eq ["Identifier - Persistent"]
      # title
      expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
    end

    it 'creates a specimen type active triple resource with the 7 required attributes' do
      @obj = build(:dataset,
        complex_specimen_type_attributes: [{
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 1',
          }],
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic_structure 1',
          }],
          description: 'Specimen description',
          complex_identifier_attributes: [{
            identifier: 'specimen/1234567'
          }],
          complex_material_type_attributes: [{
            description: 'material description'
          }],
          complex_structural_feature_attributes: [{
            description: 'structural feature description'
          }],
          title: 'Specimen 1'
        }]
      )
      # chemical composition
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
      expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier).to be_empty
      # crystallographic structure
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
      expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier).to be_empty
      # description
      expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
      # identifier
      expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
      expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
      # material type
      expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
      expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to eq ['material description']
      expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to be_empty
      expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to be_empty
      expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier).to be_empty
      # purchase record
      expect(@obj.complex_specimen_type.first.complex_purchase_record).to be_empty
      # shape
      expect(@obj.complex_specimen_type.first.complex_shape).to be_empty
      # state of matter
      expect(@obj.complex_specimen_type.first.complex_state_of_matter).to be_empty
      # structural feature
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to eq ['structural feature description']
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to be_empty
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to be_empty
      expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier).to be_empty
      # title
      expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
    end

    it 'rejects a specimen type active triple with no identifier' do
      skip
      @obj = build(:dataset,
        complex_specimen_type_attributes: [{
          complex_chemical_composition_attributes: [{
            description: 'chemical composition 1',
          }],
          complex_crystallographic_structure_attributes: [{
            description: 'crystallographic_structure 1',
          }],
          description: 'Specimen description',
          complex_material_type_attributes: [{
            material_sub_type: 'some sub material type',
          }],
          complex_structural_feature_attributes: [{
            sub_category: 'structural feature sub category',
          }],
          title: 'Specimen 1'
        }]
      )
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with some required and some non-required information' do
      skip
      @obj = build(:dataset,
        complex_specimen_type_attributes: [{
          complex_chemical_composition_attributes: [{
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/1234567'
            }],
          }],
          complex_crystallographic_structure_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/123456'],
              label: ['Local']
            }],
          }],
          description: 'Specimen description',
          complex_identifier_attributes: [{
            identifier: 'specimen/1234567'
          }],
          complex_material_type_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['material/ewfqwefqwef'],
              label: ['Local']
            }],
          }],
          complex_purchase_record_attributes: [{
            date: ['2018-02-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/123456'],
              label: ['Local']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss',
              purpose: 'Supplier',
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar',
              purpose: 'Manufacturer',
            }],
            purchase_record_item: ['Has a purchase record item'],
            title: 'Purchase record title'
          }],
          complex_shape_attributes: [{
            description: 'shape description',
          }],
          complex_state_of_matter_attributes: [{
            description: 'state of matter description',
          }],
          complex_structural_feature_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['structural_feature/123456'],
              label: ['Local']
            }]
          }],
          title: 'Specimen 1'
        }]
      )
      expect(@obj.complex_specimen_type).to be_empty
    end
  end

  describe 'synthesis_and_processing' do
    it 'has synthesis_and_processing' do
      @obj = build(:dataset, synthesis_and_processing: ['Synthesis and processing methods'])
      expect(@obj.synthesis_and_processing).to eq ['Synthesis and processing methods']
    end
  end

  describe 'custom_property' do
    it 'creates a custom property (additional metadata) active triple resource with all the attributes' do
      @obj = build(:dataset,
        custom_property_attributes: [{
          label: 'Full name',
          description: 'My full name is ...'
        }]
      )
      expect(@obj.custom_property.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.custom_property.first.id).to include('#key_value')
      expect(@obj.custom_property.first.label).to eq ['Full name']
      expect(@obj.custom_property.first.description).to eq ['My full name is ...']
    end

    it 'rejects a custom property (additional metadata) active triple with no label' do
      @obj = build(:dataset,
        custom_property_attributes: [{
          description: 'Local date'
        }]
      )
      expect(@obj.custom_property).to be_empty
    end

    it 'rejects a custom property (additional metadata) active triple with no description' do
      @obj = build(:dataset,
        custom_property_attributes: [{
          label: 'Local date'
        }]
      )
      expect(@obj.custom_property).to be_empty
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:dataset,
        complex_identifier_attributes: [{
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
      @obj = build(:dataset,
        complex_identifier_attributes: [{
          identifier: '1234'
        }]
      )
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no identifier' do
      @obj = build(:dataset,
        complex_identifier_attributes: [{
          label: 'Local'
        }]
      )
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'nims_pid' do
    it 'has nims_pid as singular' do
      @obj = build(:dataset, nims_pid: 'nims:12345678')
      expect(@obj.nims_pid).to eq 'nims:12345678'
    end
  end

  describe 'complex_event' do
    it 'creates an event active triple resource with all the attributes' do
      @obj = build(:dataset, complex_event_attributes: [
        {
          end_date: '2019-01-01',
          invitation_status: true,
          place: '221B Baker Street',
          start_date: '2018-12-25',
          title: 'A Title'
        }
      ])
      expect(@obj.complex_event.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_event.first.id).to include('#event')
      expect(@obj.complex_event.first.end_date).to eq ['2019-01-01']
      expect(@obj.complex_event.first.invitation_status).to eq [true]
      expect(@obj.complex_event.first.place).to eq ['221B Baker Street']
      expect(@obj.complex_event.first.start_date).to eq ['2018-12-25']
      expect(@obj.complex_event.first.title).to eq ['A Title']
    end
  end

  describe 'complex_source' do
    it 'creates a complex source active triple resource with an id and all properties' do
      @obj = build(:dataset,
        complex_source_attributes: [{
          alternative_title: 'Sub title for journal',
          complex_person_attributes: [{
            name: 'AR',
            role: 'Editor'
          }],
          end_page: '12',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          issue: '34',
          sequence_number: '1.2.2',
          start_page: '4',
          title: 'Test journal',
          total_number_of_pages: '8',
          volume: '3'
        }]
      )
      expect(@obj.complex_source.first.id).to include('#source')
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.alternative_title).to eq ['Sub title for journal']
      expect(@obj.complex_source.first.complex_person.first.name).to eq ['AR']
      expect(@obj.complex_source.first.complex_person.first.role).to eq ['Editor']
      expect(@obj.complex_source.first.end_page).to eq ['12']
      expect(@obj.complex_source.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.complex_source.first.complex_identifier.first.scheme).to eq ['Local']
      expect(@obj.complex_source.first.issue).to eq ['34']
      expect(@obj.complex_source.first.sequence_number).to eq ['1.2.2']
      expect(@obj.complex_source.first.start_page).to eq ['4']
      expect(@obj.complex_source.first.title).to eq ['Test journal']
      expect(@obj.complex_source.first.total_number_of_pages).to eq ['8']
      expect(@obj.complex_source.first.volume).to eq ['3']
    end
  end

  describe 'complex_funding_reference' do
    it 'creates a complex funding reference active triple resource with funding reference' do
      @obj = build(:dataset,
                   complex_funding_reference_attributes: [{
                                                            funder_identifier: 'f1234',
                                                            funder_name: 'Bank',
                                                            award_title: 'No free lunch'
                                                          }]
      )
      expect(@obj.complex_funding_reference.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_funding_reference.first.id).to include('#fundref')
      expect(@obj.complex_funding_reference.first.funder_identifier).to eq ['f1234']
      expect(@obj.complex_funding_reference.first.funder_name).to eq ['Bank']
      expect(@obj.complex_funding_reference.first.award_number).to be_empty
      expect(@obj.complex_funding_reference.first.award_uri).to be_empty
      expect(@obj.complex_funding_reference.first.award_title).to eq ['No free lunch']
    end

    it 'creates a complex funding reference active triple resource with all the attributes' do
      @obj = build(:dataset,
                   complex_funding_reference_attributes: [{
                                                            funder_identifier: 'f1234',
                                                            funder_name: 'Bank',
                                                            award_number: 'a1234',
                                                            award_uri: 'http://award.com/a1234',
                                                            award_title: 'No free lunch'
                                                          }]
      )
      expect(@obj.complex_funding_reference.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_funding_reference.first.id).to include('#fundref')
      expect(@obj.complex_funding_reference.first.funder_identifier).to eq ['f1234']
      expect(@obj.complex_funding_reference.first.funder_name).to eq ['Bank']
      expect(@obj.complex_funding_reference.first.award_number).to eq ['a1234']
      expect(@obj.complex_funding_reference.first.award_uri).to eq ['http://award.com/a1234']
      expect(@obj.complex_funding_reference.first.award_title).to eq ['No free lunch']
    end

    it 'rejects a complex funding reference active triple with no attributes' do
      @obj = build(:dataset,
                   complex_funding_reference_attributes: [{
                                                 funder_identifier: '',
                                                 funder_name: ''
                                               }]
      )
      expect(@obj.complex_funding_reference).to be_empty
    end
  end

  describe 'complex_chemical_composition' do
    it 'creates a complex chemical composition active triple resource with chemical composition' do
      @obj = build(:dataset,
                   complex_chemical_composition_attributes: [{
                     description: 'chemical composition 1',
                     complex_identifier_attributes: [{
                      identifier: 'chemical_composition/1234567',
                      scheme: 'identifier persistent'
                    }]
                   }]
      )
      expect(@obj.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_chemical_composition.first.description).to eq ['chemical composition 1']
    end

    it 'rejects a complex chemical composition active triple with no attributes' do
      @obj = build(:dataset,
                   complex_chemical_composition_attributes: [{
                                                 description: ''
                                               }]
      )
      expect(@obj.complex_chemical_composition).to be_empty
    end
  end
end
