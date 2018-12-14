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

  it 'creates a person active triple resource with an id and all properties' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_person_attributes: [
        {
          first_name: 'Foo',
          last_name: 'Bar',
          name: 'Foo Bar',
          affiliation: 'author affiliation',
          role: 'Author',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }],
          uri: 'http://localhost/person/1234567'
        }
      ]
    }
    expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_person.first.first_name).to eq ['Foo']
    expect(@obj.complex_person.first.last_name).to eq ['Bar']
    expect(@obj.complex_person.first.name).to eq ['Foo Bar']
    expect(@obj.complex_person.first.affiliation).to eq ['author affiliation']
    expect(@obj.complex_person.first.role).to eq ['Author']
    expect(@obj.complex_person.first.complex_identifier.first.identifier).to eq ['1234567']
    expect(@obj.complex_person.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_person.first.uri).to eq ['http://localhost/person/1234567']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_person_attributes: [
        {
          first_name: 'Foo',
          last_name: 'Bar',
          affiliation: 'author affiliation',
          role: 'Author'
        }
      ]
    }
    expect(@obj.complex_person.first.id).to include('#person')
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

    it 'creates a person active triple resource with name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            name: 'Anamika'
          }
        ]
      }
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with first name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            first_name: 'Anamika'
          }
        ]
      }
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to be_empty
      expect(@obj.complex_person.first.first_name).to eq ['Anamika']
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with last name' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            last_name: 'Anamika'
          }
        ]
      }
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to be_empty
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to eq ['Anamika']
      expect(@obj.complex_person.first.affiliation).to be_empty
      expect(@obj.complex_person.first.role).to be_empty
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'creates a person active triple resource with name, affiliation and role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            name: 'Anamika',
            affiliation: 'Paradise',
            role: 'Creator'
          }
        ]
      }
      expect(@obj.complex_person.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_person.first.name).to eq ['Anamika']
      expect(@obj.complex_person.first.first_name).to be_empty
      expect(@obj.complex_person.first.last_name).to be_empty
      expect(@obj.complex_person.first.affiliation).to eq ['Paradise']
      expect(@obj.complex_person.first.role).to eq ['Creator']
      expect(@obj.complex_person.first.complex_identifier).to be_empty
      expect(@obj.complex_person.first.uri).to be_empty
    end

    it 'rejects person active triple with no name and only uri' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            uri: 'http://example.com/person/123456'
          }
        ]
      }
      expect(@obj.complex_person).to be_empty
    end

    it 'rejects person active triple with no name and only role' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            role: 'Creator'
          }
        ]
      }
      expect(@obj.complex_person).to be_empty
    end

    it 'rejects person active triple with no name and only affiliation' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            affiliation: 'My department'
          }
        ]
      }
      expect(@obj.complex_person).to be_empty
    end

    it 'rejects person active triple with no name and only identifiers' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_person_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: '123456'
            }]
          }
        ]
      }
      expect(@obj.complex_person).to be_empty
    end

  end
end
