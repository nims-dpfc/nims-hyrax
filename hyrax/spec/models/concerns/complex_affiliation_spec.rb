require 'rails_helper'

RSpec.describe ComplexAffiliation do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_affiliation, predicate: ::RDF::Vocab::VMD.affiliation,
        class_name:"ComplexAffiliation"
      accepts_nested_attributes_for :complex_affiliation
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'creates an affiliation active triple resource with an id and all properties' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_affiliation_attributes: [{
        job_title: 'Tester',
        complex_organization_attributes: [{
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'org purpose',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }]
        }]
      }]
    }
    expect(@obj.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_affiliation.first.job_title).to eq ['Tester']
    expect(@obj.complex_affiliation.first.complex_organization.first.organization).to eq ['Foo']
    expect(@obj.complex_affiliation.first.complex_organization.first.sub_organization).to eq ['Bar']
    expect(@obj.complex_affiliation.first.complex_organization.first.purpose).to eq ['org purpose']
    expect(@obj.complex_affiliation.first.complex_organization.first.complex_identifier.first.identifier).to eq ['1234567']
    expect(@obj.complex_affiliation.first.complex_organization.first.complex_identifier.first.scheme).to eq ['Local']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_affiliation_attributes: [{
        job_title: 'Tester',
        complex_organization_attributes: [{
          organization: 'Foo'
        }]
      }]
    }
    expect(@obj.complex_affiliation.first.id).to include('#affiliation')
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_affiliation, reject_if: :affiliation_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates an affiliation active triple resource with job_title and organization' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_affiliation_attributes: [{
          job_title: 'Operator',
          complex_organization_attributes: [{
            organization: 'Anamika'
          }]
        }]
      }
      expect(@obj.complex_affiliation.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_affiliation.first.job_title).to eq ['Operator']
      expect(@obj.complex_affiliation.first.complex_organization.first.organization).to eq ['Anamika']
      expect(@obj.complex_affiliation.first.complex_organization.first.sub_organization).to be_empty
      expect(@obj.complex_affiliation.first.complex_organization.first.purpose).to be_empty
      expect(@obj.complex_affiliation.first.complex_organization.first.complex_identifier).to be_empty
    end

    it 'rejects an affiliation active triple with no organization and only job_title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_affiliation_attributes: [{
          job_title: 'Operator'
        }]
      }
      expect(@obj.complex_affiliation).to be_empty
    end

    it 'rejects an affiliation active triple with organization and no job_title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_affiliation_attributes: [{
          complex_organization_attributes: [{
            organization: 'Anamika'
          }]
        }]
      }
      expect(@obj.complex_affiliation).to be_empty
    end

    it 'rejects an affiliation active triple with organization defined with other properties' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_affiliation_attributes: [{
          job_title: 'Operator',
          complex_organization_attributes: [{
            sub_organization: 'My unit'
          }]
        }]
      }
      expect(@obj.complex_affiliation).to be_empty
    end

  end
end
