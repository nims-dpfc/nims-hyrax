require 'rails_helper'

RSpec.describe ComplexInstrument do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_instrument, predicate: ::RDF::Vocab::NimsRdp['instrument'], class_name:"ComplexInstrument"
      accepts_nested_attributes_for :complex_instrument
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  context 'uri with a #' do
    before do
      # special hack to force code path for testing
      allow_any_instance_of(RDF::Node).to receive(:node?) { false }
      allow_any_instance_of(RDF::Node).to receive(:start_with?) { true }
    end
    subject do
      ExampleWork
          .new({ complex_instrument_attributes: [{ title: 'Instrument 1' }]})
          .complex_instrument
          .first
          .title
    end
    it { is_expected.to eq ['Instrument 1'] }
  end

  context 'accepts valid complex_instrument_attributes' do
    subject do
      ExampleWork
          .new({ complex_instrument_attributes: complex_instrument_attributes })
          .complex_instrument
          .first
    end

    context 'with date, identifier, person and title' do
      let(:complex_instrument_attributes) do
        [{
          date_collected: ['2018-01-28'],
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }],
          complex_person_attributes: [{
            name: ['operator 1'],
            role: ['Operator']
          }],
          title: 'Instrument 1'
        }]
      end

      it 'has the correct uri' do
        expect(subject.id).to include('#instrument')
      end
    end

    context 'with all the attributes' do
      let(:complex_instrument_attributes) do
        [{
            alternative_title: 'An instrument title',
            date_collected: ['2018-02-14'],
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
              role: ['Operator']
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
        }]
      end
      it 'creates an instrument active triple resource with all the attributes' do
        expect(subject).to be_kind_of ActiveTriples::Resource
        expect(subject.alternative_title).to eq ['An instrument title']
        expect(subject.date_collected).to eq ['2018-02-14']
        expect(subject.description).to eq ['Instrument description']
        expect(subject.complex_identifier.first).to be_kind_of ActiveTriples::Resource
        expect(subject.complex_identifier.first.identifier).to eq ['123456']
        expect(subject.complex_identifier.first.label).to eq ['Local']
        expect(subject.instrument_function.first).to be_kind_of ActiveTriples::Resource
        expect(subject.instrument_function.first.column_number).to eq [1]
        expect(subject.instrument_function.first.category).to eq ['some value']
        expect(subject.instrument_function.first.sub_category).to eq ['some other value']
        expect(subject.instrument_function.first.description).to eq ['Instrument function description']
        expect(subject.manufacturer.first).to be_kind_of ActiveTriples::Resource
        expect(subject.manufacturer.first.organization).to eq ['Foo']
        expect(subject.manufacturer.first.sub_organization).to eq ['Bar']
        expect(subject.manufacturer.first.purpose).to eq ['Manufacturer']
        expect(subject.manufacturer.first.complex_identifier.first.identifier).to eq ['123456789m']
        expect(subject.manufacturer.first.complex_identifier.first.scheme).to eq ['Local']
        expect(subject.model_number).to eq ['123xfty']
        expect(subject.complex_person.first).to be_kind_of ActiveTriples::Resource
        expect(subject.complex_person.first.name).to eq ['Name of operator']
        expect(subject.complex_person.first.role).to eq ['Operator']
        expect(subject.managing_organization.first).to be_kind_of ActiveTriples::Resource
        expect(subject.managing_organization.first.organization).to eq ['Managing organization name']
        expect(subject.managing_organization.first.sub_organization).to eq ['BarBar']
        expect(subject.managing_organization.first.purpose).to eq ['Managing organization']
        expect(subject.managing_organization.first.complex_identifier.first.identifier).to eq ['123456789mo']
        expect(subject.managing_organization.first.complex_identifier.first.scheme).to eq ['Local']
        expect(subject.title).to eq ['Instrument title']
      end
    end
  end


  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_instrument, reject_if: :instrument_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    context 'accepts valid complex_instrument_attributes' do
      subject do
        ExampleWork2
            .new({ complex_instrument_attributes: complex_instrument_attributes })
            .complex_instrument
            .first
      end

      context 'date, identifier and person' do
        let(:complex_instrument_attributes) do
          [{
             date_collected: ['2018-01-28'],
               complex_identifier_attributes: [{ identifier: ['ewfqwefqwef'] }],
               complex_person_attributes: [{
                                               name: ['operator 1'],
                                               role: ['Operator']
                                           }]
           }]
        end
        it 'creates an instrument active triple resource with date, identifier and person' do
          expect(subject).to be_kind_of ActiveTriples::Resource
          expect(subject.date_collected).to eq ['2018-01-28']
          expect(subject.complex_identifier.first).to be_kind_of ActiveTriples::Resource
          expect(subject.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
          expect(subject.complex_person.first).to be_kind_of ActiveTriples::Resource
          expect(subject.complex_person.first.name).to eq ['operator 1']
          expect(subject.complex_person.first.role).to eq ['Operator']
        end
      end
    end

    context 'rejects invalid complex_instrument_attributes' do
      subject do
        ExampleWork2
            .new({ complex_instrument_attributes: complex_instrument_attributes })
            .complex_instrument
      end

      context 'rejects blank attributes' do
        let(:complex_instrument_attributes) { [] }
        it { is_expected.to be_empty }
      end

      context "temporarily disabling attribute tests" do
        # These tests are temporarily disabled because the attributes they are testing against have been temporariy disabled
        # 27/8/2019 - temporarily remove required fields (#162)
        before { skip 'temporarily disable required fields (#162)' }

        context 'rejects an instrument active triple with no date' do
          let(:complex_instrument_attributes) do
            [{
              complex_identifier_attributes: [{
                identifier: ['ewfqwefqwef'],
              }],
              complex_person_attributes: [{
                name: ['operator 1'],
                role: ['Operator']
              }]
            }]
          end

          it { is_expected.to be_empty }
        end

        context 'rejects an instrument active triple with no identifier' do
          let(:complex_instrument_attributes) do
            [{
              date_collected: ['2018-01-28'],
              complex_person_attributes: [{
                name: ['operator 1'],
                role: ['Operator']
              }]
            }]
          end
          it { is_expected.to be_empty }
        end

        context 'rejects an instrument active triple with no person' do
          let(:complex_instrument_attributes) do
            [{
              date_collected: ['2018-01-28'],
              complex_identifier_attributes: [{
                identifier: ['ewfqwefqwef'],
              }]
            }]
          end
          it { is_expected.to be_empty }
        end

        context 'rejects an instrument active triple with no date, identifier and person' do
          let(:complex_instrument_attributes) { [{ title: 'Instrument A' }] }
          it { is_expected.to be_empty }
        end
      end
    end
  end
end
