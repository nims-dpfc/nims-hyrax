# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  it 'has human readable type for the image' do
    @obj = build(:image)
    expect(@obj.human_readable_type).to eq('Image')
  end

  describe 'date_modified' do
    it 'has date_modified as singular' do
      @obj = build(:image, date_modified: '2018/04/23')
      expect(@obj.date_modified).to eq '2018/04/23'
    end
  end

  describe 'date_uploaded' do
    it 'has date_uploaded as singular' do
      @obj = build(:image, date_uploaded: '2018 01 02')
      expect(@obj.date_uploaded).to eq '2018 01 02'
    end
  end

  describe 'depositor' do
    it 'has depositor' do
      @obj = build(:image, depositor: 'Name of depositor')
      expect(@obj.depositor).to eq 'Name of depositor'
    end
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:image, title: nil)
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid, 'Validation failed: Title Your image must have a title.')
    end

    it 'has a multi valued title field' do
      @obj = build(:image, title: ['test dataset'])
      expect(@obj.title).to eq ['test dataset']
    end
  end

  describe 'based_near' do
    it 'has based_near' do
      @obj = build(:image, based_near: ['me'])
      expect(@obj.based_near).to eq ['me']
    end
  end

  describe 'bibliographic_citation' do
    it 'has bibliographic_citation' do
      @obj = build(:image, bibliographic_citation: ['bibliographic_citation 1'])
      expect(@obj.bibliographic_citation).to eq ['bibliographic_citation 1']
    end
  end

  describe 'contributor' do
    it 'has contributor' do
      @obj = build(:image, contributor: ['contributor 1'])
      expect(@obj.contributor).to eq ['contributor 1']
    end
  end

  describe 'creator' do
    it 'has creator' do
      @obj = build(:image, creator: ['Creator 1'])
      expect(@obj.creator).to eq ['Creator 1']
    end
  end

  describe 'date_created' do
    it 'has date_created' do
      @obj = build(:image, date_created: ['date_created 1'])
      expect(@obj.date_created).to eq ['date_created 1']
    end
  end

  describe 'description' do
    it 'has description' do
      @obj = build(:image, description: ['description 1'])
      expect(@obj.description).to eq ['description 1']
    end
  end

  describe 'identifier' do
    it 'has identifier' do
      @obj = build(:image, identifier: ['identifier 1'])
      expect(@obj.identifier).to eq ['identifier 1']
    end
  end

  describe 'import_url' do
    it 'has import_url as singular' do
      @obj = build(:image, import_url: 'http://example.com/import/url')
      expect(@obj.import_url).to eq 'http://example.com/import/url'
    end
  end

  describe 'keyword' do
    it 'has keyword' do
      @obj = build(:image, keyword: ['keyword 1', 'keyword 2'])
      expect(@obj.keyword).to eq ['keyword 1', 'keyword 2']
    end
  end

  describe 'label' do
    it 'has label as singular' do
      @obj = build(:image, label: 'Label 1')
      expect(@obj.label).to eq 'Label 1'
    end
  end

  describe 'language' do
    it 'has language' do
      @obj = build(:image, language: ['language 1'])
      expect(@obj.language).to eq ['language 1']
    end
  end

  describe 'part_of' do
    it 'has part_of' do
      skip 'Not using this field. Raises RSolr::Error::ConnectionRefused when added to index.'
      @obj = build(:image, part_of: ['Bigger image'])
      expect(@obj.part_of).to eq ['Bigger image']
    end
  end

  describe 'publisher' do
    it 'has publisher' do
      @obj = build(:image, publisher: ['publisher 1'])
      expect(@obj.publisher).to eq ['publisher 1']
    end
  end

  describe 'related_url' do
    it 'has related_url' do
      @obj = build(:image, related_url: ['http://example.com/related/url'])
      expect(@obj.related_url).to eq ['http://example.com/related/url']
    end
  end

  describe 'relative_path' do
    it 'has relative_path as singular' do
      @obj = build(:image, relative_path: 'relative/path/to/file')
      expect(@obj.relative_path).to eq 'relative/path/to/file'
    end
  end

  describe 'resource_type' do
    it 'has resource_type' do
      @obj = build(:image, resource_type: ['Dataset'])
      expect(@obj.resource_type).to eq ['Dataset']
    end
  end

  describe 'rights or license' do
    it 'has license (saved as dct:rights)' do
      @obj = build(:image, license: ['CC-0'])
      expect(@obj.license).to eq ['CC-0']
    end
  end

  describe 'complex_rights' do
    it 'creates a complex rights active triple resource with rights' do
      @obj = build(:image, complex_rights_attributes: [{
                                                             rights: 'cc0'
                                                         }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.id).to include('#rights')
      expect(@obj.complex_rights.first.rights).to eq ['cc0']
      expect(@obj.complex_rights.first.date).to be_empty
    end

    it 'creates a rights active triple resource with all the attributes' do
      @obj = build(:image, complex_rights_attributes: [{
                                                             date: '1978-10-28',
                                                             rights: 'CC0'
                                                         }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.date).to eq ['1978-10-28']
      expect(@obj.complex_rights.first.rights).to eq ['CC0']
    end

    it 'rejects a rights active triple with no rights' do
      @obj = build(:image, complex_rights_attributes: [{
                                                             date: '2018-01-01'
                                                         }]
      )
      expect(@obj.complex_rights).to be_empty
    end
  end

  describe 'rights_statement' do
    it 'has rights_statement' do
      @obj = build(:image, rights_statement: ['rights_statement 1'])
      expect(@obj.rights_statement).to eq ['rights_statement 1']
    end
  end

  describe 'source' do
    it 'has source' do
      @obj = build(:image, source: ['Source 1'])
      expect(@obj.source).to eq ['Source 1']
    end
  end

  describe 'subject' do
    it 'has subject' do
      @obj = build(:image, subject: ['subject 1'])
      expect(@obj.subject).to eq ['subject 1']
    end
  end

  describe 'alternative_title' do
    it 'has alternative_title as singular' do
      @obj = build(:image, alternative_title: 'Alternative Title')
      expect(@obj.alternative_title).to eq 'Alternative Title'
    end
  end

  describe 'complex_date' do
    it 'creates a date active triple resource with all the attributes' do
      @obj = build(:image, complex_date_attributes: [
        {
          date: '1978-10-28',
          description: 'Some kind of a date',
        }
      ])
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1978-10-28']
      expect(@obj.complex_date.first.description).to eq ['Some kind of a date']
    end

    it 'creates a date active triple resource with just the date' do
      @obj = build(:image, complex_date_attributes: [
        {
          date: '1984-09-01'
        }
      ])
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no date' do
      @obj = build(:image, complex_date_attributes: [
        {
          description: 'Local date'
        }
      ])
      expect(@obj.complex_date).to be_empty
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:image, complex_identifier_attributes: [{
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
      @obj = build(:image, complex_identifier_attributes: [{
                                                                 identifier: '1234'
                                                             }]
      )
      expect(@obj.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_identifier.first.identifier).to eq ['1234']
      expect(@obj.complex_identifier.first.label).to be_empty
      expect(@obj.complex_identifier.first.scheme).to be_empty
    end

    it 'rejects an identifier active triple with no identifier' do
      @obj = build(:image, complex_identifier_attributes: [{
                                                                 label: 'Local'
                                                             }]
      )
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'complex_person' do
    it 'creates a person active triple resource with name' do
      @obj = build(:image, complex_person_attributes: [{
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
      @obj = build(:image, complex_person_attributes: [{
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
      @obj = build(:image, complex_person_attributes: [{
                                                             uri: 'http://example.com/person/123456'
                                                         }]
      )
      expect(@obj.complex_person).to be_empty
    end
  end

  describe 'complex_version' do
    it 'creates a version active triple resource with all the attributes' do
      @obj = build(:image, complex_version_attributes: [{
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
      @obj = build(:image, complex_version_attributes: [{
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
      @obj = build(:image, complex_version_attributes: [{
                                                              description: 'Local version',
                                                              identifier: 'id1',
                                                              date: '2018-01-01'
                                                          }]
      )
      expect(@obj.complex_version).to be_empty
    end
  end

end
