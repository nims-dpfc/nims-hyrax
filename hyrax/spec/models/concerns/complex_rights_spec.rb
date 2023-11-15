require 'rails_helper'

RSpec.describe ComplexRights do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_rights, predicate: ::RDF::Vocab::DC11.rights,
        class_name:"ComplexRights"
      accepts_nested_attributes_for :complex_rights
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
          .new({ complex_rights_attributes: [{ rights: 'Foo' }]})
          .complex_rights
          .first
          .rights
    end
    it { is_expected.to eq ['Foo'] }
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_rights_attributes: [{
        rights: 'https://creativecommons.org/publicdomain/zero/1.0/'
      }]
    }
    expect(@obj.complex_rights.first.id).to include('#rights')
  end

  it 'creates a rights active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_rights_attributes: [{
        date: '1978-10-28',
        rights: 'https://creativecommons.org/publicdomain/zero/1.0/',
        label: 'CC-0',
        license_description: 'Some description for the rights'
      }]
    }
    expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_rights.first.date).to eq ['1978-10-28']
    expect(@obj.complex_rights.first.rights).to eq ['https://creativecommons.org/publicdomain/zero/1.0/']
    expect(@obj.complex_rights.first.label).to eq ['CC-0']
    expect(@obj.complex_rights.first.license_description).to eq ['Some description for the rights']
  end

  describe 'when reject_if is a symbol' do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_rights, reject_if: :rights_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a rights active triple resource with just the rights' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_rights_attributes: [{
          rights: 'https://creativecommons.org/publicdomain/zero/1.0/'
        }]
      }
      expect(@obj.complex_rights.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_rights.first.rights).to eq ['https://creativecommons.org/publicdomain/zero/1.0/']
      expect(@obj.complex_rights.first.date).to be_empty
    end

    it 'rejects a rights active triple with no rights' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_rights_attributes: [{
          date: '2018-01-01',
          label: 'cc0',
          license_description: 'Some description for the rights'
        }]
      }
      expect(@obj.complex_rights).to be_empty
    end
  end
end
