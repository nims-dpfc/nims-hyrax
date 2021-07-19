require 'rails_helper'

RSpec.describe ComplexPerson do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_person, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"ComplexPerson"
      accepts_nested_attributes_for :complex_person
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  describe 'complex_person_attributes' do
    subject do
       ExampleWork.new({
        complex_person_attributes: [{
          first_name: 'Foo',
          last_name: 'Bar',
          name: 'Foo Bar',
          email: 'foo.bar@example.com',
          role: 'Author',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          complex_affiliation_attributes: [{
            job_title: 'Tester',
            complex_organization_attributes: [{
               organization: 'Org',
               sub_organization: 'Sub org',
               purpose: 'org purpose',
               complex_identifier_attributes: [{
                 identifier: 'werqwerqwer',
                 scheme: 'Local'
               }]
             }]
          }],
          corresponding_author: true,
          uri: 'http://localhost/person/1234567'
        }]
      }).complex_person.first
    end

    it 'creates a person active triple resource with an id and all properties' do
      expect(subject).to be_kind_of ActiveTriples::Resource
      expect(subject.id).to include('#person')
      expect(subject.first_name).to eq ['Foo']
      expect(subject.last_name).to eq ['Bar']
      expect(subject.name).to eq ['Foo Bar']
      expect(subject.email).to eq ['foo.bar@example.com']
      expect(subject.role).to eq ['Author']
      expect(subject.complex_identifier.first.identifier).to eq ['1234567']
      expect(subject.complex_identifier.first.scheme).to eq ['Local']
      expect(subject.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
      expect(subject.complex_affiliation.first.job_title).to eq ['Tester']
      expect(subject.complex_affiliation.first.complex_organization.first.organization).to eq ['Org']
      expect(subject.complex_affiliation.first.complex_organization.first.sub_organization).to eq ['Sub org']
      expect(subject.complex_affiliation.first.complex_organization.first.purpose).to eq ['org purpose']
      expect(subject.complex_affiliation.first.complex_organization.first.complex_identifier.first.identifier).to eq ['werqwerqwer']
      expect(subject.complex_affiliation.first.complex_organization.first.complex_identifier.first.scheme).to eq ['Local']
      expect(subject.corresponding_author).to eq [true]
      expect(subject.uri).to eq ['http://localhost/person/1234567']
    end
  end

  context 'uri with a #' do
    before do
      # special hack to force code path for testing
      allow_any_instance_of(RDF::Node).to receive(:node?) { false }
      allow_any_instance_of(RDF::Node).to receive(:start_with?) { true }
    end
    subject do
      ExampleWork
          .new({ complex_person_attributes: [{uri: '#something'}]})
          .complex_person
          .first
          .uri
    end
    it { is_expected.to eq ['#something'] }
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_person, reject_if: :person_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    context 'accepts valid complex_person_attributes' do
      subject do
        ExampleWork2
            .new({ complex_person_attributes: complex_person_attributes })
            .complex_person
            .first
      end

      context 'name' do
        let(:complex_person_attributes) { [{name: 'Anamika'}] }

        it 'creates a person active triple resource with name' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.name).to eq ['Anamika']
          expect(subject.first_name).to be_empty
          expect(subject.last_name).to be_empty
          expect(subject.email).to be_empty
          expect(subject.role).to be_empty
          expect(subject.complex_identifier).to be_empty
          expect(subject.complex_affiliation).to be_empty
          expect(subject.corresponding_author).to be_empty
          expect(subject.uri).to be_empty
        end
      end

      context 'first_name' do
        let(:complex_person_attributes) { [{first_name: 'Anamika'}] }

        it 'creates a person active triple resource with first name' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.name).to be_empty
          expect(subject.first_name).to eq ['Anamika']
          expect(subject.last_name).to be_empty
          expect(subject.email).to be_empty
          expect(subject.role).to be_empty
          expect(subject.complex_identifier).to be_empty
          expect(subject.complex_affiliation).to be_empty
          expect(subject.uri).to be_empty
        end
      end

      context 'last_name' do
        let(:complex_person_attributes) { [{last_name: 'Anamika'}] }

        it 'creates a person active triple resource with last name' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.name).to be_empty
          expect(subject.first_name).to be_empty
          expect(subject.last_name).to eq ['Anamika']
          expect(subject.email).to be_empty
          expect(subject.role).to be_empty
          expect(subject.complex_identifier).to be_empty
          expect(subject.complex_affiliation).to be_empty
          expect(subject.uri).to be_empty
        end
      end

      context 'name, affiliation and role' do
        let(:complex_person_attributes) do
          [{
            name: 'Anamika',
            complex_affiliation_attributes: [{
              job_title: 'Paradise',
            }],
            role: 'Creator'
          }]
        end

        it 'creates a person active triple resource with name, affiliation and role' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.name).to eq ['Anamika']
          expect(subject.first_name).to be_empty
          expect(subject.last_name).to be_empty
          expect(subject.email).to be_empty
          expect(subject.role).to eq ['Creator']
          expect(subject.complex_identifier).to be_empty
          expect(subject.uri).to be_empty
          expect(subject.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
          expect(subject.complex_affiliation.first.job_title).to eq ['Paradise']
          expect(subject.complex_affiliation.first.complex_organization).to be_empty
        end
      end

      context 'name, affiliation org and role' do
        let(:complex_person_attributes) do
          [{
             name: 'Anamika',
             complex_affiliation_attributes: [{
                complex_organization_attributes: [{ organization: 'My department' }]
             }],
             role: 'Creator'
         }]
        end

        it 'creates a person active triple resource with name, affiliation org and role' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.name).to eq ['Anamika']
          expect(subject.first_name).to be_empty
          expect(subject.last_name).to be_empty
          expect(subject.email).to be_empty
          expect(subject.role).to eq ['Creator']
          expect(subject.complex_identifier).to be_empty
          expect(subject.uri).to be_empty
          expect(subject.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
          expect(subject.complex_affiliation.first.job_title).to be_empty
          expect(subject.complex_affiliation.first.complex_organization.first).to be_kind_of ActiveTriples::Resource
          expect(subject.complex_affiliation.first.complex_organization.first.organization).to eq ['My department']
        end
      end
    end

    context 'rejects person active triple with invalid complex_person_attributes' do
      subject do
        ExampleWork2
            .new({ complex_person_attributes: complex_person_attributes })
            .complex_person
      end

      context 'no name and only uri' do
        let(:complex_person_attributes) { [{ uri: 'http://example.com/person/123456' }] }
        it { is_expected.to be_empty }
      end

      context 'no name and only role' do
        let(:complex_person_attributes) { [{ role: 'Creator' }] }
        it { is_expected.to be_empty }
      end

      context 'no name and only affiliation' do
        let(:complex_person_attributes) do
          [{
            complex_affiliation_attributes: [{
              job_title: 'Paradise',
              complex_organization_attributes: [{
                organization: 'My department'
              }]
            }]
          }]
        end
        it { is_expected.to be_empty }
      end

      context 'no name and only identifiers' do
        let(:complex_person_attributes) do
          [{
            complex_identifier_attributes: [{
              identifier: '123456'
            }]
          }]
        end
        it { is_expected.to be_empty }
      end

      context 'no name and only email' do
        let(:complex_person_attributes) { [{ email: 'me@me.org' }] }
        it { is_expected.to be_empty }
      end
    end
  end
end
