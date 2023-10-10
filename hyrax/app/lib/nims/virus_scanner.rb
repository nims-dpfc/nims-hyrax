# Using clamav-client gem to scan for viruses
module Nims
  class VirusScanner < Hydra::Works::VirusScanner
    # Hyrax requires an infected? method and that this method return a boolean
    def infected?
      results = scan_file

      raise(StandardError, "ClamAV::ErrorResponse: #{results.error_str}") if results.instance_of? ClamAV::ErrorResponse

      results.instance_of? ClamAV::VirusResponse
    end

    # Nims custom method to return virus signature as well as virus status
    def scan_file
      host = ENV.fetch('CLAMD_HOST') { 'localhost' }
      port = ENV.fetch('CLAMD_PORT') { '3310' }
      connection = ClamAV::Connection.new(socket: ::TCPSocket.new(host, port),
                                          wrapper: ::ClamAV::Wrappers::NewLineWrapper.new)
      client = ClamAV::Client.new(connection)
      results = client.execute(ClamAV::Commands::ScanCommand.new(file))
      results[0]
    end

    def self.scan_file(file_path)
      new(file_path).scan_file
    end
  end
end
