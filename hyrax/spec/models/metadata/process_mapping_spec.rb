require 'rails_helper'

RSpec.describe Metadata::ProcessMapping do
  describe 'process_mapping' do
    include Metadata::ProcessMapping
    let(:xml) { Builder::XmlMarkup.new }
    let(:field) { 'my_field' }
    before do
      def example_func(field, xml)
        xml.tag!(field, 'example value')
      end
    end

    it 'processes a mapping function' do
      mapping = {'function': 'example_func'}
      process_mapping(xml, field, mapping)
      expect(xml).to eql('<my_field>example value<my_field>')
    end

    it 'processes a mapping array' do
      mapping = [{'function': 'example_func'}, {'function': 'example_func'}]
      process_mapping(xml, field, mapping)
      expect(xml).to eql('<my_field>example value</my_field><my_field>example value</my_field>')
    end

  end
end