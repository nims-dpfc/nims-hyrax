# NB: using spec_helper instead of rails_helper here to avoid the QA gem from overriding the module in this test
require 'spec_helper'
require_relative '../../app/models/qa'

RSpec.describe Qa do
  describe 'table_name_prefix' do
    subject { described_class.table_name_prefix }
    it { is_expected.to eql 'qa_'}
  end
end
