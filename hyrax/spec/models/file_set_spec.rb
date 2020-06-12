require 'rails_helper'

RSpec.describe FileSet do
  it "adds plain text to office_document_mime_types" do
    expect(described_class.office_document_mime_types).to include('text/plain')
  end
  it "adds csv to office_document_mime_types" do
    expect(described_class.office_document_mime_types).to include('text/csv')
  end
  it "adds tsv to office_document_mime_types" do
    expect(described_class.office_document_mime_types).to include('text/tab-separated-values')
  end
end
