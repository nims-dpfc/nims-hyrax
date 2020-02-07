module Workflow
  module GetPID
    def self.call(target:, **)
      puts "Calling GetPIDjob later:"
      puts "TARGET: #{target.inspect}"

      GetPIDJob.perform_later(target)
    end
  end
end
