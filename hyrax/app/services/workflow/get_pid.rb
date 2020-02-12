module Workflow
  module GetPID
    def self.call(target:, **)
      GetPIDJob.perform_later(target)
    end
  end
end
