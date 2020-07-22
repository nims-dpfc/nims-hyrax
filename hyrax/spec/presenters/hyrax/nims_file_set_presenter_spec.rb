require 'rails_helper'

RSpec.describe Hyrax::NimsFileSetPresenter do
  let(:presenter) { described_class.new(solr_document, nil) }
  let(:solr_document) { double(mime_type: mime_type) }

  describe 'mime_type' do
    subject { presenter.mime_type }
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      it { is_expected.to eql('some/mime_type') }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe 'csv?' do
    subject { presenter.csv? }
    context 'text/csv' do
      let(:mime_type) { 'text/csv' }
      it { is_expected.to be_truthy }
    end
    context 'APPLICATION/CSV' do
      let(:mime_type) { 'APPLICATION/CSV' }
      it { is_expected.to be_truthy }
    end
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      it { is_expected.to be_falsey }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      it { is_expected.to be_falsey }
    end
  end

  describe 'tsv?' do
    subject { presenter.tsv? }
    context 'text/tab-separated-values' do
      let(:mime_type) { 'text/tab-separated-values' }
      it { is_expected.to be_truthy }
    end
    context 'APPLICATION/TAB-SEPARATED-VALUES' do
      let(:mime_type) { 'APPLICATION/TAB-SEPARATED-VALUES' }
      it { is_expected.to be_truthy }
    end
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      it { is_expected.to be_falsey }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      it { is_expected.to be_falsey }
    end
  end
end
