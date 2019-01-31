require 'rails_helper'

RSpec.describe ComplexInstrument do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_instrument, predicate: ::RDF::Vocab::NimsRdp['instrument'],
        class_name:"ComplexInstrument"
      accepts_nested_attributes_for :complex_instrument
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
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
        }],
        title: 'Instrument 1'
      }]
    }
    expect(@obj.complex_instrument.first.id).to include('#instrument')
  end

  it 'creates an instrument active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_instrument_attributes: [
        {
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
        }
      ]
    }
    expect(@obj.complex_instrument.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_instrument.first.alternative_title).to eq ['An instrument title']
    expect(@obj.complex_instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_instrument.first.complex_date.first.date).to eq ['2018-02-14']
    expect(@obj.complex_instrument.first.description).to eq ['Instrument description']
    expect(@obj.complex_instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_instrument.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_instrument.first.complex_identifier.first.label).to eq ['Local']
    expect(@obj.complex_instrument.first.function_1).to eq ['Has a function']
    expect(@obj.complex_instrument.first.function_2).to eq ['Has two functions']
    expect(@obj.complex_instrument.first.manufacturer).to eq ['Manufacturer name']
    expect(@obj.complex_instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_instrument.first.complex_person.first.name).to eq ['Name of operator']
    expect(@obj.complex_instrument.first.complex_person.first.role).to eq ['Operator']
    expect(@obj.complex_instrument.first.organization).to eq ['Organisation']
    expect(@obj.complex_instrument.first.title).to eq ['Instrument title']
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

    it 'creates an instrument active triple resource with date, identifier and person' do
      @obj = ExampleWork2.new
      @obj.attributes = {
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
      }
      expect(@obj.complex_instrument.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_date.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_date.first.date).to eq ['2018-01-28']
      expect(@obj.complex_instrument.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_instrument.first.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument.first.complex_person.first.name).to eq ['operator 1']
      expect(@obj.complex_instrument.first.complex_person.first.role).to eq ['Operator']
    end

    it 'rejects an instrument active triple with no date' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }],
          complex_person_attributes: [{
            name: ['operator 1'],
            role: ['Operator']
          }]
        }]
      }
      expect(@obj.complex_instrument).to be_empty
    end

    it 'rejects an instrument active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_attributes: [{
          complex_date_attributes: [{
            date: ['2018-01-28'],
          }],
          complex_person_attributes: [{
            name: ['operator 1'],
            role: ['Operator']
          }]
        }]
      }
      expect(@obj.complex_instrument).to be_empty
    end

    it 'rejects an instrument active triple with no person' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_attributes: [{
          complex_date_attributes: [{
            date: ['2018-01-28'],
          }],
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_instrument).to be_empty
    end

    it 'rejects an instrument active triple with no date, identifier and person' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_attributes: [{
          title: 'Instrument A',
        }]
      }
      expect(@obj.complex_instrument).to be_empty
    end

  end
end
