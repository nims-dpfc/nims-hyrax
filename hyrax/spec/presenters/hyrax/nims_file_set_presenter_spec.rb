require 'rails_helper'

RSpec.describe Hyrax::NimsFileSetPresenter do
  let(:presenter) { described_class.new(solr_document, nil) }
  let(:solr_document) { double(mime_type: mime_type, file_format: file_format ) }

  describe 'mime_type' do
    subject { presenter.mime_type }
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      let(:file_format) { 'some format' }
      it { is_expected.to eql('some/mime_type') }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      let(:file_format) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe 'csv?' do
    subject { presenter.csv? }
    context 'text/csv' do
      let(:mime_type) { 'text/csv' }
      let(:file_format) { nil }
     it { is_expected.to be_truthy }
    end
    context 'APPLICATION/CSV' do
      let(:mime_type) { 'APPLICATION/CSV' }
      let(:file_format) { nil }
     it { is_expected.to be_truthy }
    end
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      let(:file_format) { nil }
     it { is_expected.to be_falsey }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      let(:file_format) { nil }
     it { is_expected.to be_falsey }
    end
  end

  describe 'tsv?' do
    subject { presenter.tsv? }
    context 'text/tab-separated-values' do
      let(:mime_type) { 'text/tab-separated-values' }
      let(:file_format) { nil }
     it { is_expected.to be_truthy }
    end
    context 'APPLICATION/TAB-SEPARATED-VALUES' do
      let(:mime_type) { 'APPLICATION/TAB-SEPARATED-VALUES' }
      let(:file_format) { nil }
     it { is_expected.to be_truthy }
    end
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      let(:file_format) { nil }
     it { is_expected.to be_falsey }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      let(:file_format) { nil }
     it { is_expected.to be_falsey }
    end
  end

  describe 'json?' do
    subject { presenter.json? }
    context 'application/json' do
      let(:mime_type) { 'application/json' }
      let(:file_format) { nil }
      it { is_expected.to be_truthy }
    end
    context 'APPLICATION/JSON' do
      let(:mime_type) { 'APPLICATION/JSON' }
      let(:file_format) { nil }
      it { is_expected.to be_truthy }
    end
    context 'JSON format' do
      let(:mime_type) { 'text/plain' }
      let(:file_format) { 'json (JSON Data Interchange Format, Plain text, JSON data)' }
      it { is_expected.to be_truthy }
    end
    context 'plain json format' do
      let(:mime_type) { 'text/plain' }
      let(:file_format) { 'plain (JSON Data Interchange Format, Plain text)' }
      it { is_expected.to be_truthy }
    end
    context 'some/mime_type' do
      let(:mime_type) { 'some/mime_type' }
      let(:file_format) { nil }
      it { is_expected.to be_falsey }
    end
    context 'no mime type' do
      let(:mime_type) { nil }
      let(:file_format) { nil }
      it { is_expected.to be_falsey }
    end
  end
end
