require 'rails_helper'

RSpec.describe ComplexMaterialType do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_material_type, predicate: ::RDF::Vocab::NimsRdp['material-type'],
        class_name:"ComplexMaterialType"
      accepts_nested_attributes_for :complex_material_type
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
          .new({ complex_material_type_attributes: [{ description: 'Foo' }]})
          .complex_material_type
          .first
          .description
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_material_type_attributes: [{
        description: 'material description',
        material_type: 'some value',
        material_sub_type: 'some other value'
      }]
    }
    expect(@obj.complex_material_type.first.id).to include('#material_type')
  end

  it 'creates a complex material type active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_material_type_attributes: [{
        description: 'material description',
        material_type: 'some value',
        material_sub_type: 'some other value',
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
          label: ['Local']
        }],
      }]
    }
    expect(@obj.complex_material_type.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_material_type.first.description).to eq ['material description']
    expect(@obj.complex_material_type.first.material_type).to eq ['some value']
    expect(@obj.complex_material_type.first.material_sub_type).to eq ['some other value']
    expect(@obj.complex_material_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_material_type.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
    expect(@obj.complex_material_type.first.complex_identifier.first.label).to eq ['Local']

  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_material_type, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a material type active triple resource with just the description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_material_type_attributes: [{
          description: 'Material description 55'
        }]
      }
      expect(@obj.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_material_type.first.description).to eq ['Material description 55']
      expect(@obj.complex_material_type.first.material_type).to be_empty
      expect(@obj.complex_material_type.first.material_sub_type).to be_empty
      expect(@obj.complex_material_type.first.complex_identifier).to be_empty
    end

    it 'creates a material type active triple resource with just the material_type' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_material_type_attributes: [{
          material_type: 'asdfg'
        }]
      }
      expect(@obj.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_material_type.first.description).to be_empty
      expect(@obj.complex_material_type.first.material_type).to eq ['asdfg']
      expect(@obj.complex_material_type.first.material_sub_type).to be_empty
      expect(@obj.complex_material_type.first.complex_identifier).to be_empty
    end

    it 'creates a material type type active triple resource with just the material_sub_type' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_material_type_attributes: [{
          material_sub_type: 'asdfg'
        }]
      }
      expect(@obj.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_material_type.first.description).to be_empty
      expect(@obj.complex_material_type.first.material_type).to be_empty
      expect(@obj.complex_material_type.first.material_sub_type).to eq ['asdfg']
      expect(@obj.complex_material_type.first.complex_identifier).to be_empty
    end

    it 'creates a material type type active triple resource with just the material_sub_type' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_material_type_attributes: [{
          complex_identifier_attributes: [{
            identifier: 'ewfqwefqwef'
          }],
        }]
      }
      expect(@obj.complex_material_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_material_type.first.description).to be_empty
      expect(@obj.complex_material_type.first.material_type).to be_empty
      expect(@obj.complex_material_type.first.material_sub_type).to be_empty
      expect(@obj.complex_material_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_material_type.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_material_type.first.complex_identifier.first.label).to be_empty
    end

    it 'rejects a material type type active triple with no values' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_material_type_attributes: [{
          description: nil,
          material_type: ''
        }]
      }
      expect(@obj.complex_material_type).to be_empty
    end
  end
end
