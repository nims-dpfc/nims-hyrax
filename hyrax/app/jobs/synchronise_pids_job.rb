# Synchronises with the NIMS PID API
require "json-api-vanilla"
class SynchronisePIDsJob < ApplicationJob
  # @param work [ActiveFedora::Base] the work object
  def perform(work)
    # not sure what to do here
    puts "Synchronising PIDs for work: #{work.inspect}"
  end
end
