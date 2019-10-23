require 'rails_helper'

RSpec.describe ::ApplicationJob, :type => :job do
  it { expect(described_class).to be < ActiveJob::Base }
end
