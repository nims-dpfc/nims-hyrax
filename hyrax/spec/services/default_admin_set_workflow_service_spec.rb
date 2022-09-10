require 'rails_helper'

RSpec.describe DefaultAdminSetWorkflowService do

  describe "#run" do

    it "sets the default workflow for the default admin set" do
      described_class.run
      default_admin_set_id = AdminSet.find_or_create_default_admin_set_id
      default_admin_set = AdminSet.find(default_admin_set_id)
      expect(default_admin_set.active_workflow.name).to eq "nims_mediated_deposit"
    end
  end
end
