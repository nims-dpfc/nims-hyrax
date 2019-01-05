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
          title: 'A relation title',
          url: 'http://example.com/relation',
          relationship: 'IsPartOf'
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
          title: 'My first publication',
          url: 'http://example.com/relation',
          complex_identifier_attributes: [{
            identifier: ['123456'],
            label: ['local']
          }],
          relationship: 'IsPartOf'
        }
      ]
    }
    expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_relation.first.title).to eq ['My first publication']
    expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
    expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['local']
    expect(@obj.complex_relation.first.relationship).to eq ['IsPartOf']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_relation, reject_if: :relation_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a relation active triple resource with title and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            title: 'A relation title',
            relationship: 'IsPartOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A relation title']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['IsPartOf']
    end

    it 'creates a relation active triple resource with url and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation',
            relationship: 'isPreviousVersionOf'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to be_empty
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['isPreviousVersionOf']
    end

    it 'creates a relation active triple resource with identifier and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: ['123456']
            }],
            relationship: 'isSupplementTo'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to be_empty
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['isSupplementTo']
    end

    it 'creates a relation active triple resource with title, url and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            title: 'A relation title',
            url: 'http://example.com/relation',
            relationship: 'isContinuedBy'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A relation title']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['isContinuedBy']
    end

    it 'creates a relation active triple resource with title, identifier and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            title: 'A relation title',
            complex_identifier_attributes: [{
              identifier: ['123456']
            }],
            relationship: 'isContinuedBy'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A relation title']
      expect(@obj.complex_relation.first.url).to be_empty
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to be_empty
      expect(@obj.complex_relation.first.relationship).to eq ['isContinuedBy']
    end

    it 'creates a relation active triple resource with title, url, identifier and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            title: 'A relation title',
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
            }],
            relationship: 'isDocumentedBy'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.title).to eq ['A relation title']
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['Local']
      expect(@obj.complex_relation.first.relationship).to eq ['isDocumentedBy']
    end

    it 'creates a relation active triple resource with url, identifier and relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            url: 'http://example.com/relation',
            complex_identifier_attributes: [{
              identifier: ['123456'],
              label: 'Local'
            }],
            relationship: 'isDerivedFrom'
          }
        ]
      }
      expect(@obj.complex_relation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.url).to eq ['http://example.com/relation']
      expect(@obj.complex_relation.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_relation.first.complex_identifier.first.identifier).to eq ['123456']
      expect(@obj.complex_relation.first.complex_identifier.first.label).to eq ['Local']
      expect(@obj.complex_relation.first.relationship).to eq ['isDerivedFrom']
    end

    it 'rejects relation active triple with just title and no relationship' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            title: 'Local'
          }
        ]
      }
      expect(@obj.complex_relation).to be_empty
    end

    it 'rejects relation active triple with just url and no relationship' do
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

    it 'rejects relation active triple with just identifier and no relationship' do
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

    it 'rejects relation active triple with just reltionship and no identifying information' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_relation_attributes: [
          {
            relationship: 'isPartOf'
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
            title: 'test relation',
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

  end
end
