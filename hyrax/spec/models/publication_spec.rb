# Generated via
#  `rails generate hyrax:work Publication`
require 'rails_helper'


RSpec.describe Publication do
  it 'has human readable type for the publication' do
    @obj = build(:publication)
    expect(@obj.human_readable_type).to eq('Publication')
  end

  describe 'date_modified' do
    it 'has date_modified as singular' do
      @obj = build(:publication, date_modified: '2018/04/23')
      expect(@obj.date_modified).to eq '2018/04/23'
    end
  end

  describe 'date_uploaded' do
    it 'has date_uploaded as singular' do
      @obj = build(:publication, date_uploaded: '2018 01 02')
      expect(@obj.date_uploaded).to eq '2018 01 02'
    end
  end

  describe 'depositor' do
    it 'has depositor' do
      @obj = build(:publication, depositor: 'Name of depositor')
      expect(@obj.depositor).to eq 'Name of depositor'
    end
  end

  describe 'title' do
    it 'requires title' do
      @obj = build(:publication, title: nil)
      expect{@obj.save!}.to raise_error(ActiveFedora::RecordInvalid, 'Validation failed: Title Your publication must have a title.')
    end

    it 'has a multi valued title field' do
      @obj = build(:publication, title: ['test dataset'])
      expect(@obj.title).to eq ['test dataset']
    end
  end

  describe 'based_near' do
    it 'has based_near' do
      @obj = build(:publication, based_near: ['me'])
      expect(@obj.based_near).to eq ['me']
    end
  end

  describe 'bibliographic_citation' do
    it 'has bibliographic_citation' do
      @obj = build(:publication, bibliographic_citation: ['bibliographic_citation 1'])
      expect(@obj.bibliographic_citation).to eq ['bibliographic_citation 1']
    end
  end

  describe 'contributor' do
    it 'has contributor' do
      @obj = build(:publication, contributor: ['contributor 1'])
      expect(@obj.contributor).to eq ['contributor 1']
    end
  end

  describe 'creator' do
    it 'has creator' do
      @obj = build(:publication, creator: ['Creator 1'])
      expect(@obj.creator).to eq ['Creator 1']
    end
  end

  describe 'date_created' do
    it 'has date_created' do
      @obj = build(:publication, date_created: ['date_created 1'])
      expect(@obj.date_created).to eq ['date_created 1']
    end
  end

  describe 'description' do
    it 'has description' do
      @obj = build(:publication, description: ['description 1'])
      expect(@obj.description).to eq ['description 1']
    end
  end

  describe 'identifier' do
    it 'has identifier' do
      @obj = build(:publication, identifier: ['identifier 1'])
      expect(@obj.identifier).to eq ['identifier 1']
    end
  end

  describe 'import_url' do
    it 'has import_url as singular' do
      @obj = build(:publication, import_url: 'http://example.com/import/url')
      expect(@obj.import_url).to eq 'http://example.com/import/url'
    end
  end

  describe 'keyword' do
    it 'has keyword' do
      @obj = build(:publication, keyword: ['keyword 1', 'keyword 2'])
      expect(@obj.keyword).to eq ['keyword 1', 'keyword 2']
    end
  end

  describe 'label' do
    it 'has label as singular' do
      @obj = build(:publication, label: 'Label 1')
      expect(@obj.label).to eq 'Label 1'
    end
  end

  describe 'language' do
    it 'has language' do
      @obj = build(:publication, language: ['language 1'])
      expect(@obj.language).to eq ['language 1']
    end
  end

  describe 'part_of' do
    it 'has part_of' do
      skip 'Not using this field. Raises RSolr::Error::ConnectionRefused when added to index.'
      @obj = build(:publication, part_of: ['Bigger publication'])
      expect(@obj.part_of).to eq ['Bigger publication']
    end
  end

  describe 'publisher' do
    it 'has publisher' do
      @obj = build(:publication, publisher: ['publisher 1'])
      expect(@obj.publisher).to eq ['publisher 1']
    end
  end

  describe 'related_url' do
    it 'has related_url' do
      @obj = build(:publication, related_url: ['http://example.com/related/url'])
      expect(@obj.related_url).to eq ['http://example.com/related/url']
    end
  end

  describe 'relative_path' do
    it 'has relative_path as singular' do
      @obj = build(:publication, relative_path: 'relative/path/to/file')
      expect(@obj.relative_path).to eq 'relative/path/to/file'
    end
  end

  describe 'resource_type' do
    it 'has resource_type' do
      @obj = build(:publication, resource_type: ['Dataset'])
      expect(@obj.resource_type).to eq ['Dataset']
    end
  end

  describe 'rights or license' do
    it 'has license (saved as dct:rights)' do
      @obj = build(:publication, license: ['CC-0'])
      expect(@obj.license).to eq ['CC-0']
    end
  end

  describe 'supervisor_approval' do
    it 'has supervisor_approval' do
      @obj = build(:publication, supervisor_approval: ['Kosuke Tanabe 2019.08.01'])
      expect(@obj.supervisor_approval).to eq ['Kosuke Tanabe 2019.08.01']
    end
  end

  describe 'complex_rights' do
    it 'creates a complex rights active triple resource with rights' do
      @obj = build(:publication, complex_rights_attributes: [{
                                                             rights: 'cc0'
                                                         }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.id).to include('#rights')
      expect(@obj.complex_rights.first.rights).to eq ['cc0']
      expect(@obj.complex_rights.first.date).to be_empty
    end

    it 'creates a rights active triple resource with all the attributes' do
      @obj = build(:publication, complex_rights_attributes: [{
                                                             date: '1978-10-28',
                                                             rights: 'CC0'
                                                         }]
      )
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.date).to eq ['1978-10-28']
      expect(@obj.complex_rights.first.rights).to eq ['CC0']
    end

    it 'rejects a rights active triple with no rights' do
      @obj = build(:publication, complex_rights_attributes: [{
                                                             date: '2018-01-01'
                                                         }]
      )
      expect(@obj.complex_rights).to be_empty
    end
  end

  describe 'rights_statement' do
    it 'has rights_statement' do
      @obj = build(:publication, rights_statement: ['rights_statement 1'])
      expect(@obj.rights_statement).to eq ['rights_statement 1']
    end
  end

  describe 'source' do
    it 'has source' do
      @obj = build(:publication, source: ['Source 1'])
      expect(@obj.source).to eq ['Source 1']
    end
  end

  describe 'subject' do
    it 'has subject' do
      @obj = build(:publication, subject: ['subject 1'])
      expect(@obj.subject).to eq ['subject 1']
    end
  end

  describe 'alternative_title' do
    it 'has alternative_title as singular' do
      @obj = build(:publication, alternative_title: 'Alternative Title')
      expect(@obj.alternative_title).to eq 'Alternative Title'
    end
  end

  describe 'complex_date' do
    it 'creates a date active triple resource with all the attributes' do
      @obj = build(:publication, complex_date_attributes: [
        {
          date: '2019-05-28',
          description: 'Published',
        }
      ])
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['2019-05-28']
      expect(@obj.complex_date.first.description).to eq ['Published']
    end

    it 'creates a date active triple resource with just the date' do
      @obj = build(:publication, complex_date_attributes: [
        {
          date: '1984-09-01'
        }
      ])
      expect(@obj.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_date.first.date).to eq ['1984-09-01']
      expect(@obj.complex_date.first.description).to be_empty
    end

    it 'rejects a date active triple with no date' do
      @obj = build(:publication, complex_date_attributes: [
        {
          description: 'Local date'
        }
      ])
      expect(@obj.complex_date).to be_empty
    end
  end

  describe 'complex_identifier' do
    it 'creates an identifier active triple resource with all the attributes' do
      @obj = build(:publication,
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
      @obj = build(:publication,
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
      @obj = build(:publication,
        complex_identifier_attributes: [{
          label: 'Local'
        }]
      )
      expect(@obj.complex_identifier).to be_empty
    end
  end

  describe 'complex_person' do
    it 'creates a person active triple resource with name' do
      @obj = build(:publication,
        complex_person_attributes: [{
          name: 'Anamika'
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.complex_affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with name, affiliation and role' do
      @obj = build(:publication, complex_person_attributes: [{
          name: 'Anamika',
          complex_affiliation_attributes: [{
            job_title: 'Master',
            complex_organization_attributes: [{
              organization: 'Org',
              sub_organization: 'Sub org',
              purpose: 'org purpose',
            }]
          }],
          role: 'Creator'
        }]
      )
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.complex_affiliation.first.job_title).to eq ['Master']
      expect(@obj.complex_person.first.complex_affiliation.first.complex_organization.first.organization).to eq ['Org']
      expect(@obj.complex_person.first.complex_affiliation.first.complex_organization.first.sub_organization).to eq ['Sub org']
      expect(@obj.complex_person.first.complex_affiliation.first.complex_organization.first.purpose).to eq ['org purpose']
      expect(@obj.complex_person.first.complex_affiliation.first.complex_organization.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.role).to eq ['Creator']
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'rejects person active triple with no name and only uri' do
      @obj = build(:publication, complex_person_attributes: [{
          uri: 'http://example.com/person/123456'
        }]
      )
      expect(@obj.complex_person).to be_empty
    end
  end

  describe 'complex_version' do
    it 'creates a version active triple resource with all the attributes' do
      @obj = build(:publication,
        complex_version_attributes: [{
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
      @obj = build(:publication,
        complex_version_attributes: [{
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
      @obj = build(:publication,
        complex_version_attributes: [{
          description: 'Local version',
          identifier: 'id1',
          date: '2018-01-01'
        }]
      )
      expect(@obj.complex_version).to be_empty
    end
  end

  describe 'complex_event' do
    it 'creates an event active triple resource with all the attributes' do
      @obj = build(:publication, complex_event_attributes: [
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

    it 'creates an event active triple resource with just the title' do
      @obj = build(:publication,
        complex_event_attributes: [{
          title: 'Some Title'
        }]
      )
      expect(@obj.complex_event.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_event.first.id).to include('#event')
      expect(@obj.complex_event.first.end_date).to be_empty
      expect(@obj.complex_event.first.invitation_status).to be_empty
      expect(@obj.complex_event.first.place).to be_empty
      expect(@obj.complex_event.first.start_date).to be_empty
      expect(@obj.complex_event.first.title).to eq ['Some Title']
    end

    it 'rejects an event active triple with no title' do
      @obj = build(:publication,
        complex_event_attributes: [{
          end_date: '2019-01-01',
          invitation_status: true
        }]
      )
      expect(@obj.complex_event).to be_empty
    end
  end

  describe 'issue' do
    it 'has issue' do
      @obj = build(:publication, issue: 'iss_1')
      expect(@obj.issue).to eq 'iss_1'
    end
  end

  describe 'place' do
    it 'has place' do
      @obj = build(:publication, place: '221B Baker Street')
      expect(@obj.place).to eq '221B Baker Street'
    end
  end

  describe 'table_of_contents' do
    it 'has table_of_contents' do
      @obj = build(:publication, table_of_contents: "Some long table of text")
      expect(@obj.table_of_contents).to eq "Some long table of text"
    end
  end

  describe 'total_number_of_pages' do
    it 'has total_number_of_pages' do
      @obj = build(:publication, total_number_of_pages: 1010)
      expect(@obj.total_number_of_pages).to eq 1010
    end
  end

  describe 'complex_source' do
    it 'creates a complex source active triple resource with an id and all properties' do
      @obj = build(:publication,
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

    it 'creates a complex source active triple resource with title' do
      @obj = build(:publication,
        complex_source_attributes: [{
          title: 'Anamika'
        }]
      )
      expect(@obj.complex_source.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_source.first.title).to eq ['Anamika']
      expect(@obj.complex_source.first.complex_person).to be_empty
      expect(@obj.complex_source.first.end_page).to be_empty
      expect(@obj.complex_source.first.issue).to be_empty
      expect(@obj.complex_source.first.sequence_number).to be_empty
      expect(@obj.complex_source.first.start_page).to be_empty
      expect(@obj.complex_source.first.total_number_of_pages).to be_empty
      expect(@obj.complex_source.first.volume).to be_empty
    end

    it 'rejects source active triple with no values ' do
      @obj = build(:publication,
        complex_source_attributes: [{
          title: ''
        }]
      )
      expect(@obj.complex_source).to be_empty
    end

    it 'rejects source active triple with nil values' do
      @obj = build(:publication,
        complex_source_attributes: [{
          sequence_number: nil
        }]
      )
      expect(@obj.complex_source).to be_empty
    end
  end

  describe 'nims_pid' do
    it 'has note_to_admin as singular' do
      @obj = build(:publication, nims_pid: 'nims:12345678')
      expect(@obj.nims_pid).to eq 'nims:12345678'
    end
  end

  describe 'note_to_admin' do
    it 'has note_to_admin as singular' do
      @obj = build(:publication, note_to_admin: 'This is a sample publication')
      expect(@obj.note_to_admin).to eq 'This is a sample publication'
    end
  end

  describe 'complex_relation' do
    it 'creates a relation active triple resource with all the attributes' do
      @obj = build(:publication,
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
  end
end
