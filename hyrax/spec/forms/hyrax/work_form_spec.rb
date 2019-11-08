require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
  it { expect(described_class).to be < Hyrax::Forms::WorkForm }
end
