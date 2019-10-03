require 'rails_helper'

RSpec.describe ComplexPurchaseRecord do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_purchase_record, predicate: ::RDF::Vocab::NimsRdp['purchase-record'],
        class_name:"ComplexPurchaseRecord"
      accepts_nested_attributes_for :complex_purchase_record
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
          .new({ complex_purchase_record_attributes: [{ title: 'Foo' }]})
          .complex_purchase_record
          .first
          .title
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_purchase_record_attributes: [{
        date: ['2018-01-28'],
        title: 'Instrument 1'
      }]
    }
    expect(@obj.complex_purchase_record.first.id).to include('#purchase_record')
  end

  it 'creates a purchase record active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_purchase_record_attributes: [{
        date: ['2018-02-14'],
        complex_identifier_attributes: [{
          identifier: ['123456'],
          label: ['Local']
        }],
        supplier_attributes: [{
          organization: 'Fooss',
          sub_organization: 'Barss',
          purpose: 'Supplier',
          complex_identifier_attributes: [{
            identifier: '123456789ss',
            scheme: 'Local'
          }]
        }],
        manufacturer_attributes: [{
          organization: 'Foo',
          sub_organization: 'Bar',
          purpose: 'Manufacturer',
          complex_identifier_attributes: [{
            identifier: '123456789m',
            scheme: 'Local'
          }]
        }],
        purchase_record_item: ['Has a purchase record item'],
        title: 'Purchase record title'
      }]
    }
    expect(@obj.complex_purchase_record.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_purchase_record.first.id).to include('#purchase_record')
    expect(@obj.complex_purchase_record.first.date).to eq ['2018-02-14']
    expect(@obj.complex_purchase_record.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_purchase_record.first.complex_identifier.first.identifier).to eq ['123456']
    expect(@obj.complex_purchase_record.first.complex_identifier.first.label).to eq ['Local']
    expect(@obj.complex_purchase_record.first.supplier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_purchase_record.first.supplier.first.organization).to eq ['Fooss']
    expect(@obj.complex_purchase_record.first.supplier.first.sub_organization).to eq ['Barss']
    expect(@obj.complex_purchase_record.first.supplier.first.purpose).to eq ['Supplier']
    expect(@obj.complex_purchase_record.first.supplier.first.complex_identifier.first.identifier).to eq ['123456789ss']
    expect(@obj.complex_purchase_record.first.supplier.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_purchase_record.first.manufacturer.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_purchase_record.first.manufacturer.first.organization).to eq ['Foo']
    expect(@obj.complex_purchase_record.first.manufacturer.first.sub_organization).to eq ['Bar']
    expect(@obj.complex_purchase_record.first.manufacturer.first.purpose).to eq ['Manufacturer']
    expect(@obj.complex_purchase_record.first.manufacturer.first.complex_identifier.first.identifier).to eq ['123456789m']
    expect(@obj.complex_purchase_record.first.manufacturer.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_purchase_record.first.purchase_record_item).to eq ['Has a purchase record item']
    expect(@obj.complex_purchase_record.first.title).to eq ['Purchase record title']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_purchase_record, reject_if: :purchase_record_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a purchase record active triple resource with date and title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_purchase_record_attributes: [{
            date: ['2018-01-28'],
            title: 'Purchase record title'
        }]
      }
      expect(@obj.complex_purchase_record.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_purchase_record.first.id).to include('#purchase_record')
      expect(@obj.complex_purchase_record.first.date).to eq ['2018-01-28']
      expect(@obj.complex_purchase_record.first.title).to eq ['Purchase record title']
    end

    it 'rejects a purchase record active triple with no date' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_purchase_record_attributes: [{
            title: 'Purchase record title'
        }]
      }
      expect(@obj.complex_purchase_record).to be_empty
    end

    it 'rejects a purchase record active triple with no title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_purchase_record_attributes: [{
            date: ['2018-01-28'],
        }]
      }
      expect(@obj.complex_purchase_record).to be_empty
    end

    it 'rejects an instrument active triple with no date and title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_purchase_record_attributes: [{
          complex_identifier: [{
            identifier: 'ewfqwefqwef'
          }],
        }]
      }
      expect(@obj.complex_purchase_record).to be_empty
    end

  end
end
