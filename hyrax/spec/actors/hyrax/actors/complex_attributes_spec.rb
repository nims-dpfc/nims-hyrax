require 'rails_helper'

RSpec.describe Hyrax::Actors::ComplexAttributes do
  let(:env) { double(curation_concern: double(updated_subresources: [], :updated_subresources= => []) ) }

  before do
    class SuperClass
      def apply_save_data_to_curation_concern(env)
      end
    end

    class TestClass < SuperClass
      include Hyrax::Actors::ComplexAttributes
    end

    class ExampleWork < ActiveFedora::Base
      property :complex_version, predicate: ::RDF::URI.new('http://www.w3.org/2002/07/owl#versionInfo'), class_name: "ComplexVersion"
      accepts_nested_attributes_for :complex_version
    end
  end

  after do
    Object.send(:remove_const, :ExampleWork)
    Object.send(:remove_const, :TestClass)
    Object.send(:remove_const, :SuperClass)
  end

  let(:test) { TestClass.new }

  describe '#apply_save_data_to_curation_concern' do
    before { test.apply_save_data_to_curation_concern(env) }
    it { expect(env.curation_concern).to have_received(:updated_subresources=).with([]) }
  end

  describe '#update_complex_metadata' do
    let(:resource) { double(complex_version: ExampleWork.new(complex_version_attributes: [{ version: '1.0' }]).complex_version) }
    before { test.update_complex_metadata(env, resource) }
    it { expect(env.curation_concern.updated_subresources).to eql([resource.complex_version]) }
  end

  describe '#complex_attributes' do
    subject { test.complex_attributes }
    it { is_expected.to match_array(%w[complex_person complex_identifier complex_rights complex_organization complex_date custom_property
            complex_specimen_type complex_version complex_relation complex_instrument complex_affiliation manufacturer managing_organization
            supplier custom_property complex_structural_feature complex_state_of_matter complex_shape complex_purchase_record
            complex_material_type instrument_function complex_chemical_composition complex_crystallographic_structure
            complex_event complex_source complex_event_date]) }
  end
end
