require 'rails_helper'

RSpec.describe Hyrax::PublicationForm do
  it { expect(described_class).to be < Hyrax::Forms::WorkForm }

  describe '#build_permitted_params' do
    subject { described_class.build_permitted_params }

    it { is_expected.to include(:member_of_collection_ids, :find_child_work) }

    context 'permitted params' do
      it do
        expect(described_class).to receive(:permitted_identifier_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_person_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_relation_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_version_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_event_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_source_params).at_least(:once).and_call_original
        expect(described_class).to receive(:permitted_custom_property_params).at_least(:once).and_call_original
        subject
      end
    end
  end
end
