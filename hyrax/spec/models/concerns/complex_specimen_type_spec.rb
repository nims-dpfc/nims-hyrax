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
        complex_chemical_composition_attributes: [{
          description: 'chemical composition 1'
        }],
        complex_crystallographic_structure_attributes: [{
          description: 'crystallographic_structure 1'
        }],
        description: 'Specimen description',
        complex_identifier_attributes: [{
          identifier: '1234567'
        }],
        complex_material_type_attributes: [{
          description: 'material description',
          material_type: 'some material type',
          material_sub_type: 'some other material sub type'
        }],
        complex_structural_feature_attributes: [{
          description: 'structural feature description',
          category: 'structural feature category',
          sub_category: 'structural feature sub category'
        }],
        title: 'Specimen 1'
      }]
    }
    expect(@obj.complex_specimen_type.first.id).to include('#specimen_type')
  end

  it 'creates a specimen type active triple resource with all the attributes' do
    @obj = ExampleWork.new
    @obj.attributes = {
      complex_specimen_type_attributes: [{
        complex_chemical_composition_attributes: [{
          description: 'chemical composition 1',
          complex_identifier_attributes: [{
            identifier: 'chemical_composition/1234567'
          }],
        }],
        complex_crystallographic_structure_attributes: [{
          description: 'crystallographic_structure 1',
          complex_identifier_attributes: [{
            identifier: ['crystallographic_structure/123456'],
            label: ['Local']
          }],
        }],
        description: 'Specimen description',
        complex_identifier_attributes: [{
          identifier: 'specimen/1234567'
        }],
        complex_material_type_attributes: [{
          description: 'material description',
          material_type: 'some material type',
          material_sub_type: 'some other material sub type',
          complex_identifier_attributes: [{
            identifier: ['material/ewfqwefqwef'],
            label: ['Local']
          }],
        }],
        complex_purchase_record_attributes: [{
          date: ['2018-02-14'],
          complex_identifier_attributes: [{
            identifier: ['purchase_record/123456'],
            label: ['Local']
          }],
          supplier_attributes: [{
            organization: 'Fooss',
            sub_organization: 'Barss',
            purpose: 'Supplier',
            complex_identifier_attributes: [{
              identifier: 'supplier/123456789',
              scheme: 'Local'
            }]
          }],
          manufacturer_attributes: [{
            organization: 'Foo',
            sub_organization: 'Bar',
            purpose: 'Manufacturer',
            complex_identifier_attributes: [{
              identifier: 'manufacturer/123456789',
              scheme: 'Local'
            }]
          }],
          purchase_record_item: ['Has a purchase record item'],
          title: 'Purchase record title'
        }],
        complex_shape_attributes: [{
          description: 'shape description',
          complex_identifier_attributes: [{
            identifier: ['shape/123456'],
            label: ['Local']
          }]
        }],
        complex_state_of_matter_attributes: [{
          description: 'state of matter description',
          complex_identifier_attributes: [{
            identifier: ['state/123456'],
            label: ['Local']
          }]
        }],
        complex_structural_feature_attributes: [{
          description: 'structural feature description',
          category: 'structural feature category',
          sub_category: 'structural feature sub category',
          complex_identifier_attributes: [{
            identifier: ['structural_feature/123456'],
            label: ['Local']
          }]
        }],
        title: 'Specimen 1'
      }]
    }
    expect(@obj.complex_specimen_type.first).to be_kind_of ActiveTriples::Resource
    # chemical composition
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first.identifier).to eq ['chemical_composition/1234567']
    expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier.first.label).to be_empty
    # crystallographic structure
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first.identifier).to eq ['crystallographic_structure/123456']
    expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier.first.label).to eq ['Local']
    # description
    expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
    # identifier
    expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
    expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
    # material type
    expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
    expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to eq ['material description']
    expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to eq ['some material type']
    expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to eq ['some other material sub type']
    expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first.identifier).to eq ['material/ewfqwefqwef']
    expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier.first.label).to eq ['Local']
    # purchase record
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.id).to include('#purchase_record')
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.date).to eq ['2018-02-14']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first.identifier).to eq ['purchase_record/123456']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.complex_identifier.first.label).to eq ['Local']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.organization).to eq ['Fooss']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.sub_organization).to eq ['Barss']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.purpose).to eq ['Supplier']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.complex_identifier.first.identifier).to eq ['supplier/123456789']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.supplier.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.organization).to eq ['Foo']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.sub_organization).to eq ['Bar']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.purpose).to eq ['Manufacturer']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.complex_identifier.first.identifier).to eq ['manufacturer/123456789']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.manufacturer.first.complex_identifier.first.scheme).to eq ['Local']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.purchase_record_item).to eq ['Has a purchase record item']
    expect(@obj.complex_specimen_type.first.complex_purchase_record.first.title).to eq ['Purchase record title']
    # shape
    expect(@obj.complex_specimen_type.first.complex_shape.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_shape.first.id).to include('#shape')
    expect(@obj.complex_specimen_type.first.complex_shape.first.description).to eq ['shape description']
    expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first.identifier).to eq ['shape/123456']
    expect(@obj.complex_specimen_type.first.complex_shape.first.complex_identifier.first.label).to eq ['Local']
    # state of matter
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.id).to include('#state_of_matter')
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.description).to eq ['state of matter description']
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first.identifier).to eq ['state/123456']
    expect(@obj.complex_specimen_type.first.complex_state_of_matter.first.complex_identifier.first.label).to eq ['Local']
    # structural feature
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to eq ['structural feature description']
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to eq ['structural feature category']
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to eq ['structural feature sub category']
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first.identifier).to eq ['structural_feature/123456']
    expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier.first.label).to eq ['Local']
    # title
    expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
  end

  describe "when reject_if is a symbol" do
    before do
      class ExampleWork2 < ExampleWork
        include ComplexValidation
        accepts_nested_attributes_for :complex_specimen_type, reject_if: :specimen_type_blank
      end
    end
    after do
      Object.send(:remove_const, :ExampleWork2)
    end

    describe 'creates a specimen type active triple resource with the 7 required attributes' do
      it 'with material description and structural description' do
        @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              description: 'material description'
            }],
            complex_structural_feature_attributes: [{
              description: 'structural feature description'
            }],
            title: 'Specimen 1'
          }]
        }
        # chemical composition
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier).to be_empty
        # crystallographic structure
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier).to be_empty
        # description
        expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
        # identifier
        expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
        expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
        # material type
        expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
        expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to eq ['material description']
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier).to be_empty
        # purchase record
        expect(@obj.complex_specimen_type.first.complex_purchase_record).to be_empty
        # shape
        expect(@obj.complex_specimen_type.first.complex_shape).to be_empty
        # state of matter
        expect(@obj.complex_specimen_type.first.complex_state_of_matter).to be_empty
        # structural feature
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to eq ['structural feature description']
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier).to be_empty
        # title
        expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
      end

      it 'with material type and structural category' do
        @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_type: 'some material type',
            }],
            complex_structural_feature_attributes: [{
              category: 'structural feature category',
            }],
            title: 'Specimen 1'
          }]
        }
        # chemical composition
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier).to be_empty
        # crystallographic structure
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier).to be_empty
        # description
        expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
        # identifier
        expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
        expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
        # material type
        expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
        expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to eq ['some material type']
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier).to be_empty
        # purchase record
        expect(@obj.complex_specimen_type.first.complex_purchase_record).to be_empty
        # shape
        expect(@obj.complex_specimen_type.first.complex_shape).to be_empty
        # state of matter
        expect(@obj.complex_specimen_type.first.complex_state_of_matter).to be_empty
        # structural feature
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to eq ['structural feature category']
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier).to be_empty
        # title
        expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
      end

      it 'with material sub type and structural sub category' do
        @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
        # chemical composition
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.id).to include('#chemical_composition')
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.description).to eq ['chemical composition 1']
        expect(@obj.complex_specimen_type.first.complex_chemical_composition.first.complex_identifier).to be_empty
        # crystallographic structure
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.id).to include('#crystallographic_structure')
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.description).to eq ['crystallographic_structure 1']
        expect(@obj.complex_specimen_type.first.complex_crystallographic_structure.first.complex_identifier).to be_empty
        # description
        expect(@obj.complex_specimen_type.first.description).to eq ['Specimen description']
        # identifier
        expect(@obj.complex_specimen_type.first.complex_identifier.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_identifier.first.id).to include('#identifier')
        expect(@obj.complex_specimen_type.first.complex_identifier.first.identifier).to eq ['specimen/1234567']
        # material type
        expect(@obj.complex_specimen_type.first.complex_material_type.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_material_type.first.id).to include('#material_type')
        expect(@obj.complex_specimen_type.first.complex_material_type.first.description).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_type).to be_empty
        expect(@obj.complex_specimen_type.first.complex_material_type.first.material_sub_type).to eq ['some sub material type']
        expect(@obj.complex_specimen_type.first.complex_material_type.first.complex_identifier).to be_empty
        # purchase record
        expect(@obj.complex_specimen_type.first.complex_purchase_record).to be_empty
        # shape
        expect(@obj.complex_specimen_type.first.complex_shape).to be_empty
        # state of matter
        expect(@obj.complex_specimen_type.first.complex_state_of_matter).to be_empty
        # structural feature
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first).to be_kind_of ActiveTriples::Resource
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.id).to include('#structural_feature')
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.description).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.category).to be_empty
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.sub_category).to eq ['structural feature sub category']
        expect(@obj.complex_specimen_type.first.complex_structural_feature.first.complex_identifier).to be_empty
        # title
        expect(@obj.complex_specimen_type.first.title).to eq ['Specimen 1']
      end
    end

    it 'rejects a specimen type active triple with no chemical composition' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no crystallographic structure' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no description' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no identifier' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no material types' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no structural features' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            title: 'Specimen 1'
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with no title' do
      skip
      @obj = ExampleWork2.new
        @obj.attributes = {
          complex_specimen_type_attributes: [{
            complex_chemical_composition_attributes: [{
              description: 'chemical composition 1',
            }],
            complex_crystallographic_structure_attributes: [{
              description: 'crystallographic_structure 1',
            }],
            description: 'Specimen description',
            complex_identifier_attributes: [{
              identifier: 'specimen/1234567'
            }],
            complex_material_type_attributes: [{
              material_sub_type: 'some sub material type',
            }],
            complex_structural_feature_attributes: [{
              sub_category: 'structural feature sub category',
            }]
          }]
        }
      expect(@obj.complex_specimen_type).to be_empty
    end

    it 'rejects a specimen type active triple with some required and some non-required information' do
      skip
      @obj = ExampleWork2.new
      @obj.attributes = {
        complex_specimen_type_attributes: [{
          complex_chemical_composition_attributes: [{
            complex_identifier_attributes: [{
              identifier: 'chemical_composition/1234567'
            }],
          }],
          complex_crystallographic_structure_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['crystallographic_structure/123456'],
              label: ['Local']
            }],
          }],
          description: 'Specimen description',
          complex_identifier_attributes: [{
            identifier: 'specimen/1234567'
          }],
          complex_material_type_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['material/ewfqwefqwef'],
              label: ['Local']
            }],
          }],
          complex_purchase_record_attributes: [{
            date: ['2018-02-14'],
            complex_identifier_attributes: [{
              identifier: ['purchase_record/123456'],
              label: ['Local']
            }],
            supplier_attributes: [{
              organization: 'Fooss',
              sub_organization: 'Barss',
              purpose: 'Supplier',
            }],
            manufacturer_attributes: [{
              organization: 'Foo',
              sub_organization: 'Bar',
              purpose: 'Manufacturer',
            }],
            purchase_record_item: ['Has a purchase record item'],
            title: 'Purchase record title'
          }],
          complex_shape_attributes: [{
            description: 'shape description',
          }],
          complex_state_of_matter_attributes: [{
            description: 'state of matter description',
          }],
          complex_structural_feature_attributes: [{
            complex_identifier_attributes: [{
              identifier: ['structural_feature/123456'],
              label: ['Local']
            }]
          }],
          title: 'Specimen 1'
        }]
      }
      expect(@obj.complex_specimen_type).to be_empty
    end
  end
end
