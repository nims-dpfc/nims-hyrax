require 'rails_helper'

RSpec.describe ::ApplicationRecord do
  subject { described_class.abstract_class }
  it { is_expected.to be true }
end
