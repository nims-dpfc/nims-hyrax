require 'rails_helper'

RSpec.describe ComplexOrganization do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_organization, predicate: ::RDF::Vocab::ORG.organization, class_name:"ComplexOrganization"
      accepts_nested_attributes_for :complex_organization
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
          .new({ complex_organization_attributes: [{ organization: 'Foo' }]})
          .complex_organization
          .first
          .organization
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'creates an organization active triple resource with an id and all properties' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_organization_attributes: [
        {
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'org purpose',
          complex_identifier_attributes: [{
            identifier: '1234567',
            scheme: 'Local'
          }]
        }
      ]
    }
    expect(@obj.complex_organization.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_organization.first.organization).to eq ['Foo']
    expect(@obj.complex_organization.first.sub_organization).to eq ['Bar']
    expect(@obj.complex_organization.first.purpose).to eq ['org purpose']
    expect(@obj.complex_organization.first.complex_identifier.first.identifier).to eq ['1234567']
    expect(@obj.complex_organization.first.complex_identifier.first.scheme).to eq ['Local']
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_organization_attributes: [
        {
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'org purpose',
        }
      ]
    }
    expect(@obj.complex_organization.first.id).to include('#organization')
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_organization, reject_if: :organization_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates an organization active triple resource with organization' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_organization_attributes: [
          {
            organization: 'Anamika'
          }
        ]
      }
      expect(@obj.complex_organization.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_organization.first.organization).to eq ['Anamika']
      expect(@obj.complex_organization.first.sub_organization).to be_empty
      expect(@obj.complex_organization.first.purpose).to be_empty
      expect(@obj.complex_organization.first.complex_identifier).to be_empty
    end


    it 'rejects an organization active triple with no organization and only sub_organization' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_organization_attributes: [
          {
            sub_organization: 'sub org'
          }
        ]
      }
      expect(@obj.complex_organization).to be_empty
    end

    it 'rejects an organization active triple with no organization and only purpose' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_organization_attributes: [
          {
            purpose: 'Org purpose'
          }
        ]
      }
      expect(@obj.complex_organization).to be_empty
    end

    it 'rejects an organization active triple with no organization and only identifiers' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_organization_attributes: [
          {
            complex_identifier_attributes: [{
              identifier: '123456'
            }]
          }
        ]
      }
      expect(@obj.complex_organization).to be_empty
    end

  end
end
