require 'rails_helper'

RSpec.describe Qa do
  describe 'table_name_prefix' do
    subject { described_class.table_name_prefix }
    it {is_expected.to eql 'qa_'}
  end
end
