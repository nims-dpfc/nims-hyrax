require 'rails_helper'

RSpec.describe ComplexShape do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_shape, predicate: ::RDF::Vocab::NimsRdp.shape,
        class_name:"ComplexShape"
      accepts_nested_attributes_for :complex_shape
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_shape_attributes: [{
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
        }],
        description: 'shape 1'
      }]
    }
    expect(@obj.complex_shape.first.id).to include('#shape')
  end

  it 'creates a shape active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_shape_attributes: [{
        description: 'shape description',
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }]
      }]
    }
    expect(@obj.complex_shape.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_shape.first.id).to include('#shape')
    expect(@obj.complex_shape.first.description).to eq ['shape description']
    expect(@obj.complex_shape.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_shape.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_shape.first.complex_identifier.first.label).to eq ['Local']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_shape, reject_if: :identifier_description_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a shape active triple resource with description and identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_shape_attributes: [{
          description: 'chemical composition 12',
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_shape.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_shape.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_shape.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_shape.first.description).to eq ['chemical composition 12']
    end

    it 'rejects a shape active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_shape_attributes: [{
          complex_identifier_attributes: [{
            identifier: ['ewfqwefqwef'],
          }]
        }]
      }
      expect(@obj.complex_shape).to be_empty
    end

    it 'rejects a shape active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_shape_attributes: [{
          description: 'composition 1'
        }]
      }
      expect(@obj.complex_shape).to be_empty
      @obj2 = ExampleWork2.new
      @obj2.attributes = {
        complex_shape_attributes: [{
          description: 'shape description',
          complex_identifier_attributes: [{
            label: ['Local']
          }]
        }]
      }
      expect(@obj2.complex_shape).to be_empty
    end
  end
end
