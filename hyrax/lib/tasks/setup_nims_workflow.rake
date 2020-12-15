namespace :ngdr do
  desc 'Setup NIMS customized deposit workflow'
  task :"setup_workflow" => :environment do |task, args|
    DefaultAdminSetWorkflowService.run
  end
end
