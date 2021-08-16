require 'rails_helper'
require 'securerandom'

RSpec.describe HyraxHelper, type: :helper do
  describe '#available_translations' do
    it 'returns available translations' do
      expect(helper.available_translations).to eql('en' => 'English')
    end
  end

  describe '#available_file_set_ids' do
    let(:file_set) { create(:file_set, id: SecureRandom.hex(10)) }
    let(:dataset) { create(:dataset, members: [file_set], id: SecureRandom.hex(10)) }
    let(:solr_document) { SolrDocument.new(dataset.to_solr) }
    let(:ability) { Ability.new(create(:user, id: SecureRandom.hex(10))) }
    let(:presenter) { Hyrax::WorkShowPresenter.new(solr_document, ability) }

    before do
      allow(presenter).to receive(:file_set_presenters).and_return([file_set])
    end

    context 'user can read file_set' do
      before do
        allow(ability).to receive(:can?).and_return(true)
      end
      it 'returns available_file_set_ids' do
        expect(helper.available_file_set_ids(presenter, ability)).to eq([file_set.id])
      end
    end

    context 'user cannot read file_set' do
      before do
        allow(ability).to receive(:can?).and_return(false)
      end

      it 'returns available_file_set_ids' do
        expect(helper.available_file_set_ids(presenter, ability)).to eq([])
      end
    end
  end

  describe '#within_file_size_threshold?' do
    let(:file_set) { create(:file_set, id: SecureRandom.hex(10)) }

    before do
      CharacterizeJob.perform_now(file_set, file_set.original_file.id)
    end

    context 'above threshold' do
      before do
        allow(helper).to receive(:total_size_file_sets).with([file_set.id]).and_return(100_000_001)
      end

      it 'returns true' do
        expect(helper.within_file_size_threshold?([file_set.id])).to eq(false)
      end
    end

    context 'below threshold' do
      it 'returns true' do
        expect(helper.within_file_size_threshold?([file_set.id])).to eq(true)
      end
    end
  end
end
