require 'rails_helper'

RSpec.describe Hyrax::NimsFileSetHelper, type: :helper do
  let(:presenter) { Hyrax::NimsFileSetPresenter.new(solr_document, nil) }
  let(:solr_document) { SolrDocument.new(mime_type_ssi: mime_type, id: '12345') }

  describe '#nims_media_display' do
    let(:mime_type) { 'text/csv' }
    subject { helper.nims_media_display(presenter) }
    it { is_expected.to have_css('a', text: 'Preview') }
    it { is_expected.to have_css('a', text: 'Download the file') }
  end

  describe '#nims_media_display_partial' do
    subject { helper.nims_media_display_partial(presenter) }

    context 'image' do
      let(:mime_type) { 'image/tiff' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/image' }
    end

    context 'video' do
      let(:mime_type) { 'video/mpeg' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/video' }
    end

    context 'audio' do
      let(:mime_type) { 'audio/ogg' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/audio' }
    end

    context 'pdf' do
      let(:mime_type) { 'application/pdf' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/pdf' }
    end

    context 'office_document' do
      let(:mime_type) { 'application/vnd.ms-powerpoint' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/office_document' }
    end

    context 'csv' do
      let(:mime_type) { 'text/csv' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/csv' }
    end

    context 'tsv' do
      let(:mime_type) { 'text/csv' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/csv' }
    end

    context 'anything else' do
      let(:mime_type) { 'foo/bar' }
      it { is_expected.to eql 'hyrax/file_sets/media_display/default' }
    end
  end
end
