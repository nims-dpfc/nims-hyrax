require 'rails_helper'

RSpec.describe ROCrateExportService do

  before(:each) do
    file_set = FactoryBot.create(:file_set, :long_filename)
    @dataset = create(:dataset, members: [file_set])
  end

  it "should export ro-crate file" do
    service = ROCrateExportService.new(@dataset)
    expect(service.export_as_zip('test.zip')).to be_truthy
  end
end
