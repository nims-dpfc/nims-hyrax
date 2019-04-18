require 'rails_helper'

RSpec.describe ComplexInstrumentFunction do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_instrument_function, predicate: ::RDF::Vocab::NimsRdp["instrument-function"],
        class_name:"ComplexInstrumentFunction"
      accepts_nested_attributes_for :complex_instrument_function
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_instrument_function_attributes: [{
        column_number: 1,
        category: 'some value',
        sub_category: 'some other value',
        description: 'Instrument function description'
      }]
    }
    expect(@obj.complex_instrument_function.first.id).to include('#category_code')
  end

  it 'creates a complex category active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_instrument_function_attributes: [{
        column_number: 1,
        category: 'some value',
        sub_category: 'some other value',
        description: 'Instrument function description'
      }]
    }
    expect(@obj.complex_instrument_function.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_instrument_function.first.column_number).to eq [1]
    expect(@obj.complex_instrument_function.first.category).to eq ['some value']
    expect(@obj.complex_instrument_function.first.sub_category).to eq ['some other value']
    expect(@obj.complex_instrument_function.first.description).to eq ['Instrument function description']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_instrument_function, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a category type active triple resource with just the column_number' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_function_attributes: [{
          column_number: 5
        }]
      }
      expect(@obj.complex_instrument_function.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument_function.first.column_number).to eq [5]
      expect(@obj.complex_instrument_function.first.category).to be_empty
      expect(@obj.complex_instrument_function.first.sub_category).to be_empty
      expect(@obj.complex_instrument_function.first.description).to be_empty
    end

    it 'creates a category type active triple resource with just the category' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_function_attributes: [{
          category: 'asdfg'
        }]
      }
      expect(@obj.complex_instrument_function.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument_function.first.column_number).to be_empty
      expect(@obj.complex_instrument_function.first.category).to eq ['asdfg']
      expect(@obj.complex_instrument_function.first.sub_category).to be_empty
      expect(@obj.complex_instrument_function.first.description).to be_empty
    end

    it 'creates a category type active triple resource with just the sub_category' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_function_attributes: [{
          sub_category: 'asdfg'
        }]
      }
      expect(@obj.complex_instrument_function.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument_function.first.column_number).to be_empty
      expect(@obj.complex_instrument_function.first.category).to be_empty
      expect(@obj.complex_instrument_function.first.sub_category).to eq ['asdfg']
      expect(@obj.complex_instrument_function.first.description).to be_empty
    end

    it 'creates a category type active triple resource with just the description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_function_attributes: [{
          description: 'Instrument function description'
        }]
      }
      expect(@obj.complex_instrument_function.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_instrument_function.first.column_number).to be_empty
      expect(@obj.complex_instrument_function.first.category).to be_empty
      expect(@obj.complex_instrument_function.first.sub_category).to be_empty
      expect(@obj.complex_instrument_function.first.description).to eq ['Instrument function description']
    end

    it 'rejects a category type active triple with no values' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_instrument_function_attributes: [{
          column_number: nil,
          category: ''
        }]
      }
      expect(@obj.complex_instrument_function).to be_empty
    end
  end
end
