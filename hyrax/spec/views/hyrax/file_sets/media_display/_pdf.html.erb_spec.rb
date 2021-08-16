# frozen_string_literal: true
# require 'securerandom'

require 'rails_helper'
RSpec.describe 'hyrax/file_sets/media_display/_pdf.html.erb', type: :view do
  let(:config) { double }
  let(:link) { true }
  let(:file_set) { FileSet.create(id: SecureRandom.hex(10), visibility: 'authenticated') }

  before do
    allow(Hyrax.config).to receive(:display_media_download_link?).and_return(link)
    allow(view).to receive(:thumbnail_url).and_return(file_set.id)
  end

  context "download links" do
    it "draws the view with the link" do
      allow(view).to receive(:can?).with(:download, file_set.id).and_return(true)
      render 'hyrax/file_sets/media_display/pdf', file_set: file_set
      expect(rendered).to have_css('a', text: 'Download PDF')
    end
  end

  context "no download links" do
    it "doesn't draw the view without the link" do
      allow(view).to receive(:can?).with(:download, file_set.id).and_return(false)
      render 'hyrax/file_sets/media_display/pdf', file_set: file_set
      expect(rendered).not_to have_css('a', text: 'Download PDF')
    end
  end
end
