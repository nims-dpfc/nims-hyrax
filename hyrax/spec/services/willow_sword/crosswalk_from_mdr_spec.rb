require 'rails_helper'

RSpec.describe WillowSword::CrosswalkFromMdr do
  let(:crosswalk) { described_class.new(File.join(fixture_path, 'xml', 'test.xml'), {} ) }

  describe '#map_xml' do
    before { crosswalk.map_xml }
    subject { crosswalk.mapped_metadata }

    it 'parses the xml' do
      is_expected.to eql({
          :complex_identifier_attributes => [
              {:identifier => "123456789unknown", :scheme => "identifier local"},
              {:identifier => "project0012345*", :scheme => "project id"}
          ],
          :complex_person_attributes => [
              {:name => "Test1, TEST1", :complex_identifier_attributes => [{:identifier => "00112233", :scheme => "nims person id"}], :role => "author"},
              {:name => "Test2, TEST2", :complex_identifier_attributes => [{:identifier => "00445566", :scheme => "nims person id"}], :role => "data depositor"},
              {:name => "Test3, TEST3", :complex_identifier_attributes => [{:identifier => "00778899", :scheme => "nims person id"}], :role => "data curator"},
              {:name => "Test4, TEST4", :complex_identifier_attributes => [{:identifier => "09876543", :scheme => "nims person id"}], :role => "contact person"}
          ],
          :complex_organization_attributes => [
              {:organization => "NIMS"}
          ],
          :complex_date_attributes => [
              {:date => "2018-12-30", :description => "http://purl.org/dc/terms/created"},
              {:date => "2018-12-31", :description => "http://bibframe.org/vocab/changeDate"}
          ],
          :data_origin => ["experiments"],
          :visibility => "open",
          :title => ["unknown"],
          :complex_specimen_type_attributes => [
              {:complex_identifier_attributes => [{:identifier => "999999999", :scheme => "identifier local"}], :description => ["unknown"]}
          ]
      })
    end
  end

  describe '#get_files' do
    let(:other_filepath) { File.join(fixture_path, 'xml', 'other.txt') }
    before { crosswalk.get_files }
    subject { crosswalk.files_metadata }
    it { is_expected.to eql([{ "filename" => 'other.txt', "filepath" => other_filepath }] )}
  end
end
