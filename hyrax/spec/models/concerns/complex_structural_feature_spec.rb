require 'rails_helper'

RSpec.describe ComplexStructuralFeature do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_structural_feature, predicate: ::RDF::Vocab::NimsRdp['structural-feature'],
        class_name:"ComplexStructuralFeature"
      accepts_nested_attributes_for :complex_structural_feature
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
          .new({ complex_structural_feature_attributes: [{ description: 'Foo' }]})
          .complex_structural_feature
          .first
          .description
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_structural_feature_attributes: [{
        description: 'structural feature description',
        category: 'some value',
        sub_category: 'some other value'
      }]
    }
    expect(@obj.complex_structural_feature.first.id).to include('#structural_feature')
  end

  it 'creates a complex structural feature type active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_structural_feature_attributes: [{
        description: 'structural feature description',
        category: 'some value',
        sub_category: 'some other value',
        complex_identifier_attributes: [{
          identifier: ['ewfqwefqwef'],
          label: ['Local']
        }],
      }]
    }
    expect(@obj.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_structural_feature.first.id).to include('#structural_feature')
    expect(@obj.complex_structural_feature.first.description).to eq ['structural feature description']
    expect(@obj.complex_structural_feature.first.category).to eq ['some value']
    expect(@obj.complex_structural_feature.first.sub_category).to eq ['some other value']
    expect(@obj.complex_structural_feature.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_structural_feature.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
    expect(@obj.complex_structural_feature.first.complex_identifier.first.label).to eq ['Local']

  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_structural_feature, reject_if: :all_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a structural feature type active triple resource with just the description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_structural_feature_attributes: [{
          description: 'structural feature description 55'
        }]
      }
      expect(@obj.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_structural_feature.first.description).to eq ['structural feature description 55']
      expect(@obj.complex_structural_feature.first.category).to be_empty
      expect(@obj.complex_structural_feature.first.sub_category).to be_empty
      expect(@obj.complex_structural_feature.first.complex_identifier).to be_empty
    end

    it 'creates a structural feature type active triple resource with just the category' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_structural_feature_attributes: [{
          category: 'asdfg'
        }]
      }
      expect(@obj.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_structural_feature.first.description).to be_empty
      expect(@obj.complex_structural_feature.first.category).to eq ['asdfg']
      expect(@obj.complex_structural_feature.first.sub_category).to be_empty
      expect(@obj.complex_structural_feature.first.complex_identifier).to be_empty
    end

    it 'creates a structural feature type type active triple resource with just the sub_category' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_structural_feature_attributes: [{
          sub_category: 'asdfg'
        }]
      }
      expect(@obj.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_structural_feature.first.description).to be_empty
      expect(@obj.complex_structural_feature.first.category).to be_empty
      expect(@obj.complex_structural_feature.first.sub_category).to eq ['asdfg']
      expect(@obj.complex_structural_feature.first.complex_identifier).to be_empty
    end

    it 'creates a structural feature type type active triple resource with just the sub_category' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_structural_feature_attributes: [{
          complex_identifier_attributes: [{
            identifier: 'ewfqwefqwef'
          }],
        }]
      }
      expect(@obj.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_structural_feature.first.description).to be_empty
      expect(@obj.complex_structural_feature.first.category).to be_empty
      expect(@obj.complex_structural_feature.first.sub_category).to be_empty
      expect(@obj.complex_structural_feature.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_structural_feature.first.complex_identifier.first.identifier).to eq ['ewfqwefqwef']
      expect(@obj.complex_structural_feature.first.complex_identifier.first.label).to be_empty
    end

    it 'rejects a structural feature type type active triple with no values' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_structural_feature_attributes: [{
          description: nil,
          category: ''
        }]
      }
      expect(@obj.complex_structural_feature).to be_empty
    end
  end
end
