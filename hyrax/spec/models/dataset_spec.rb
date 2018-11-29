# Generated via
#  `rails generate hyrax:work Dataset`
require 'rails_helper'

RSpec.describe Dataset do
  it 'has human readable type for the dataset' do
    @obj = build(:dataset)
    expect(@obj.human_readable_type).to eq('Dataset')
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

  describe 'analysis_field' do
    it 'has analysis_field' do
      @obj = build(:dataset, analysis_field: ['Analysis'])
      expect(@obj.analysis_field).to eq ['Analysis']
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

  describe 'material_types' do
    it 'has material_types' do
      @obj = build(:dataset, material_types: ['material types'])
      expect(@obj.material_types).to eq ['material types']
    end
  end

  describe 'measurement_environment' do
    it 'has measurement_environment' do
      @obj = build(:dataset, measurement_environment: ['Measurement environment'])
      expect(@obj.measurement_environment).to eq ['Measurement environment']
    end
  end

  describe 'processing_environment' do
    it 'has processing_environment' do
      @obj = build(:dataset, processing_environment: ['processing environment methods'])
      expect(@obj.processing_environment).to eq ['processing environment methods']
    end
  end

  describe 'properties_addressed' do
    it 'has properties_addressed' do
      @obj = build(:dataset, properties_addressed: ['properties addressed'])
      expect(@obj.properties_addressed).to eq ['properties addressed']
    end
  end

  describe 'structural_features' do
    it 'has structural_features' do
      @obj = build(:dataset, structural_features: ['Structural features'])
      expect(@obj.structural_features).to eq ['Structural features']
    end
  end

  describe 'synthesis_and_processing' do
    it 'has synthesis_and_processing' do
      @obj = build(:dataset, synthesis_and_processing: ['Synthesis and processing methods'])
      expect(@obj.synthesis_and_processing).to eq ['Synthesis and processing methods']
    end
  end

  describe 'creator' do
    it 'has creator' do
      @obj = build(:dataset, creator: ['Creator 1'])
      expect(@obj.creator).to eq ['Creator 1']
    end
  end

  describe 'contributor' do
    it 'has contributor' do
      @obj = build(:dataset, contributor: ['contributor 1'])
      expect(@obj.contributor).to eq ['contributor 1']
    end
  end

  describe 'complex_person' do
    it 'creates a person active triple resource with name' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_person_attributes: [
          {
            name: 'Anamika'
          }
        ]
      }
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
      @obj = build(:dataset)
      @obj.attributes = {
        complex_person_attributes: [
          {
            name: 'Anamika',
            affiliation: 'Paradise',
            role: 'Creator'
          }
        ]
      }
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
      @obj = build(:dataset)
      @obj.attributes = {
        complex_person_attributes: [
          {
            uri: 'http://example.com/person/123456'
          }
        ]
      }
      expect(@obj.complex_person).to be_empty
    end
  end

  describe 'description' do
    it 'has description' do
      @obj = build(:dataset, description: ['description 1'])
      expect(@obj.description).to eq ['description 1']
    end
  end

  describe 'keyword' do
    it 'has keyword' do
      @obj = build(:dataset, keyword: ['keyword 1', 'keyword 2'])
      expect(@obj.keyword).to eq ['keyword 1', 'keyword 2']
    end
  end

  describe 'language' do
    it 'has language' do
      @obj = build(:dataset, language: ['language 1'])
      expect(@obj.language).to eq ['language 1']
    end
  end

  describe 'publisher' do
    it 'has publisher' do
      @obj = build(:dataset, publisher: ['publisher 1'])
      expect(@obj.publisher).to eq ['publisher 1']
    end
  end

  describe 'subject' do
    it 'has subject' do
      @obj = build(:dataset, subject: ['subject 1'])
      expect(@obj.subject).to eq ['subject 1']
    end
  end

  describe 'bibliographic_citation' do
    it 'has bibliographic_citation' do
      @obj = build(:dataset, bibliographic_citation: ['bibliographic_citation 1'])
      expect(@obj.bibliographic_citation).to eq ['bibliographic_citation 1']
    end
  end

  describe 'date_created' do
    it 'has date_created' do
      @obj = build(:dataset, date_created: ['date_created 1'])
      expect(@obj.date_created).to eq ['date_created 1']
    end
  end

  describe 'identifier' do
    it 'has identifier' do
      @obj = build(:dataset, identifier: ['identifier 1'])
      expect(@obj.identifier).to eq ['identifier 1']
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_identifier_attributes: [
          {
            identifier: '0000-0000-0000-0000',
            scheme: 'uri_of_ORCID_scheme',
            label: 'ORCID'
          }
        ]
      }
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['0000-0000-0000-0000']
      expect(@obj.complex_identifier.first.scheme).to eq ['uri_of_ORCID_scheme']
      expect(@obj.complex_identifier.first.label).to eq ['ORCID']
    end

    it 'creates an identifier active triple resource with just the identifier' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_identifier_attributes: [
          {
            identifier: '1234'
          }
        ]
      }
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no ientifier' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_identifier_attributes: [
          {
            label: 'Local'
          }
        ]
      }
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'part_of' do
    it 'has part_of' do
      @obj = build(:dataset, part_of: ['Bigger dataset'])
      expect(@obj.part_of).to eq ['Bigger dataset']
    end
  end

  # resource_type
  describe 'resource_type' do
    it 'has resource_type' do
      @obj = build(:dataset, resource_type: ['Dataset'])
      expect(@obj.resource_type).to eq ['Dataset']
    end
  end

  # rights
  describe 'rights or license' do
    it 'has license (saved as dct:rights)' do
      @obj = build(:dataset, license: ['CC-0'])
      expect(@obj.license).to eq ['CC-0']
    end
  end

  # source
  describe 'source' do
    it 'has source' do
      @obj = build(:dataset, source: ['Source 1'])
      expect(@obj.source).to eq ['Source 1']
    end
  end

  # rights_statement
  describe 'rights_statement' do
    it 'has rights_statement' do
      @obj = build(:dataset, rights_statement: ['rights_statement 1'])
      expect(@obj.rights_statement).to eq ['rights_statement 1']
    end
  end

  # label
  describe 'label' do
    it 'has label as singular' do
      @obj = build(:dataset, label: 'Label 1')
      expect(@obj.label).to eq 'Label 1'
    end
  end

  # based_near
  describe 'based_near' do
    it 'has based_near' do
      @obj = build(:dataset, based_near: ['me'])
      expect(@obj.based_near).to eq ['me']
    end
  end

  # related_url
  describe 'related_url' do
    it 'has related_url' do
      @obj = build(:dataset, related_url: ['http://example.com/related/url'])
      expect(@obj.related_url).to eq ['http://example.com/related/url']
    end
  end

  # import_url
  describe 'import_url' do
    it 'has import_url as singular' do
      @obj = build(:dataset, import_url: 'http://example.com/import/url')
      expect(@obj.import_url).to eq 'http://example.com/import/url'
    end
  end

  # relative_path
  describe 'relative_path' do
    it 'has relative_path as singular' do
      @obj = build(:dataset, relative_path: 'relative/path/to/file')
      expect(@obj.relative_path).to eq 'relative/path/to/file'
    end
  end

  # date_modified
  describe 'date_modified' do
    it 'has date_modified as singular' do
      @obj = build(:dataset, date_modified: '2018/04/23')
      expect(@obj.date_modified).to eq '2018/04/23'
    end
  end

  # date_uploaded
  describe 'date_uploaded' do
    it 'has date_uploaded as singular' do
      @obj = build(:dataset, date_uploaded: '2018 01 02')
      expect(@obj.date_uploaded).to eq '2018 01 02'
    end
  end

  # depositor
  describe 'depositor' do
    it 'has depositor' do
      @obj = build(:dataset, depositor: 'Name of depositor')
      expect(@obj.depositor).to eq 'Name of depositor'
    end
  end

  # status_at_start
  describe 'status_at_start' do
    it 'has status_at_start' do
      @obj = build(:dataset, status_at_start: 'Start status')
      expect(@obj.status_at_start).to eq 'Start status'
    end
  end

  # status_at_end
  describe 'status_at_end' do
    it 'has status_at_end' do
      @obj = build(:dataset, status_at_end: 'End status')
      expect(@obj.status_at_end).to eq 'End status'
    end
  end

  # instrument
  describe 'instrument' do
    it 'has instrument' do
      @obj = build(:dataset, instrument: 'instrument 1')
      expect(@obj.instrument).to eq 'instrument 1'
    end
  end

  # complex_date
  describe 'complex_date' do
    it 'creates a date active triple resource with all the attributes' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_date_attributes: [
          {
            date: '1978-10-28',
            description: 'Some kind of a date',
          }
        ]
      }
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1978-10-28']
      expect(@obj.complex_date.first.description).to eq ['Some kind of a date']
    end

    it 'creates a date active triple resource with just the date' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_date_attributes: [
          {
            date: '1984-09-01'
          }
        ]
      }
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no ientifier' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_date_attributes: [
          {
            description: 'Local date'
          }
        ]
      }
      expect(@obj.complex_date).to be_empty
    end
  end

  # complex_relation
  describe 'complex_relation' do
    it 'creates a relation active triple resource with all the attributes' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: ['local']
            }],
            relationship_name: 'Is part of',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['local']
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with label, url, identifier and relationship role' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456']
            }],
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'rejects relation active triple with url' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with identifier' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_relation_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
            }],
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with reltionship name' do
      @obj = build(:dataset)
      @obj.attributes = {
        complex_relation_attributes: [
          {
            relationship_name: 'is part of'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end
  end
  #
end
