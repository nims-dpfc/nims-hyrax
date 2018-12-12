require 'rails_helper'

RSpec.describe ComplexSpecimenType do
  before do
    class ExampleWork < ActiveFedora::Base
      property :complex_specimen_type, predicate: ::RDF::Vocab::NimsRdp['specimen-type'],
        class_name:"ComplexSpecimenType"
      accepts_nested_attributes_for :complex_specimen_type
    end
  end
  after do
    Object.send(:remove_const, :ExampleWork)
  end

  it 'has the correct uri' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_specimen_type_attributes: [{
        chemical_composition: 'chemical composition',
        crystalograpic_structure: 'crystalograpic structure',
        description: 'Description',
        complex_identifier_attributes: [{
          identifier: '1234567'
        }],
        material_types: 'material types',
        structural_features: 'structural features',
        title: 'Instrument 1'
      }]
    }
    expect(@obj.complex_specimen_type.first.id).to include('#specimen')
  end

  it 'creates a specimen type active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_specimen_type_attributes: [{
        chemical_composition: 'chemical composition',
        crystalograpic_structure: 'crystalograpic structure',
        description: 'Description',
        complex_identifier_attributes: [{
          identifier: '1234567'
        }],
        material_types: 'material types',
        purchase_record_attributes: [{
          date: '2018-09-23',
          title: 'Purchase record 1'
        }],
        complex_relation_attributes: [{
          url: 'http://example.com/relation',
          relationship_role: 'is part of'
        }],
        structural_features: 'structural features',
        title: 'Instrument 1'
      }]
    }
    expect(@obj.complex_specimen_type.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.chemical_composition).to eq ['chemical composition']
    expect(@obj.complex_specimen_type.first.crystalograpic_structure).to eq ['crystalograpic structure']
    expect(@obj.complex_specimen_type.first.description).to eq ['Description']
    expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['1234567']
    expect(@obj.complex_specimen_type.first.material_types).to eq ['material types']
    expect(@obj.complex_specimen_type.first.purchase_record.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.purchase_record.first.date).to eq ['2018-09-23']
    expect(@obj.complex_specimen_type.first.purchase_record.first.title).to eq ['Purchase record 1']
    expect(@obj.complex_specimen_type.first.complex_relation.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_relation.first.url).to eq ['http://example.com/relation']
    expect(@obj.complex_specimen_type.first.complex_relation.first.relationship_role).to eq ['is part of']
    expect(@obj.complex_specimen_type.first.structural_features).to eq ['structural features']
    expect(@obj.complex_specimen_type.first.title).to eq ['Instrument 1']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexAttributes
        accepts_nested_attributes_for :complex_specimen_type, reject_if: :specimen_type_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    it 'creates a specimen type active triple resource with the 7 required attributes' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.chemical_composition).to eq ['chemical composition']
      expect(@obj.complex_specimen_type.first.crystalograpic_structure).to eq ['crystalograpic structure']
      expect(@obj.complex_specimen_type.first.description).to eq ['Description']
      expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
      expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['1234567']
      expect(@obj.complex_specimen_type.first.material_types).to eq ['material types']
      expect(@obj.complex_specimen_type.first.structural_features).to eq ['structural features']
      expect(@obj.complex_specimen_type.first.title).to eq ['Instrument 1']
    end

    it 'rejects a specimen type active triple with no chemical composition' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no crystalograpic structure' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no description' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            label: 'ORCID'
          }],
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no identifier' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          material_types: 'material types',
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no material types' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          structural_features: 'structural features',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no structural features' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          title: 'Instrument 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no title' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          chemical_composition: 'chemical composition',
          crystalograpic_structure: 'crystalograpic structure',
          description: 'Description',
          complex_identifier_attributes: [{
            identifier: '1234567'
          }],
          material_types: 'material types',
          structural_features: 'structural features'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with only purchase record and relation' do
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          purchase_record_attributes: [{
            date: '2018-09-23',
            title: 'Purchase record 1'
          }],
          complex_relation_attributes: [{
            url: 'http://example.com/relation',
            relationship_role: 'is part of'
          }]
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end

  end
end
