require 'rails_helper'

RSpec.describe ComplexRelation do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_relation, predicate: ::RDF::Vocab::DC.relation,
        class_name:"ComplexRelation"
      accepts_nested_attributes_for :complex_relation
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_relation_attributes: [
        {
          label: 'A relation label',
          url: 'http://example.com/relation',
          relationship_name: 'Is part of',
          relationship_role: 'http://example.com/isPartOf'
        }
      ]
    }
    expect(@obj.complex_relation.first.id).to include('#relation')
  end

  it 'creates a relation active triple resource with all the attributes' do
    @obj = ExampleWork.new
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

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexAttributes
        accepts_nested_attributes_for :complex_relation, reject_if: :relation_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a relation active triple resource with label and relationship name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            relationship_name: 'Is part of'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to be_empty
    end

    it 'creates a relation active triple resource with label and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with url and relationship name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation',
            relationship_name: 'Is part of'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to be_empty
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to be_empty
    end

    it 'creates a relation active triple resource with url and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to be_empty
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with identifier and relationship name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: ['123456']
            }],
            relationship_name: 'Is part of'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to be_empty
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to be_empty
    end

    it 'creates a relation active triple resource with identifier and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'local'
            }],
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to be_empty
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['local']
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with label, url and relationship name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            url: 'http://example.com/relation',
            relationship_name: 'Is part of'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to be_empty
    end

    it 'creates a relation active triple resource with label, identifier and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            complex_identifier_attributes: [{
              identifier: ['123456']
            }],
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with label, relationship name and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            relationship_name: 'Is part of',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.label).to eq ['A relation label']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship_name).to eq ['Is part of']
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with label, url, identifier and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'A relation label',
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
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
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['Local']
      expect(@obj.complex_relation.first.relationship_name).to be_empty
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'creates a relation active triple resource with url, identifier, relationship name and relationship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
            }],
            relationship_name: 'is part of',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['Local']
      expect(@obj.complex_relation.first.relationship_name).to eq ['is part of']
      expect(@obj.complex_relation.first.relationship_role).to eq ['http://example.com/isPartOf']
    end

    it 'rejects relation active triple with label' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'Local'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with url' do
      @obj = ExampleWork2.new
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
      @obj = ExampleWork2.new
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
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            relationship_name: 'is part of'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with reltionship role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with no reltionship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            label: 'test relation',
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
            }]
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with no identifying information' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            relationship_name: 'is part of',
            relationship_role: 'http://example.com/isPartOf'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

  end
end
