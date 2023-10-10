require 'rails_helper'
require 'fileutils'
require 'tempfile'
require 'pathname'

# Check for github actions runner when setting file path
# Github actions needs a different path than the local vm
RSpec.describe Nims::VirusScanner do
  subject(:scanner) { described_class.new(file) }

  context 'when a file is not infected' do
    src_path = Pathname.new('spec/fixtures/files/test.txt').realpath.to_s
    let(:file) { '/shared/uploads/runner/text.txt' }

    before do
      ClamAV::Client.any_instance.stub(:execute).and_return([ClamAV::SuccessResponse.new(file)])
    end

    it 'does not have a virus custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::SuccessResponse
    end

    it 'does not have a virus normal hyrax scan' do
      expect(scanner).not_to be_infected
    end
  end

  context 'when it cannot find the file' do
    let(:file) { 'not/a/file.txt' }
    before do
      ClamAV::Client.any_instance.stub(:execute).and_return([ClamAV::ErrorResponse.new('error')])
    end

    it 'raises an error' do
      expect { scanner.infected? }.to raise_error(StandardError, 'ClamAV::ErrorResponse: error')
    end
  end

  context 'when a file is infected' do
    let(:file) { '/shared/uploads/runner/virus.txt' }

    before do
      ClamAV::Client.any_instance.stub(:execute).and_return([ClamAV::VirusResponse.new(file, 'virus_name')])
    end

    it 'has a virus nims custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::VirusResponse
    end

    it 'has a virus nims normal hyrax scan' do
      expect(scanner).to be_infected
    end
  end

  context 'when a file name has special characters' do
    let(:file) { '/shared/uploads/runner/odd_chars_+.txt' }

    before do
      ClamAV::Client.any_instance.stub(:execute).and_return([ClamAV::SuccessResponse.new(file)])
    end

    it 'can perform a nims custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::SuccessResponse
    end

    it 'does not have a virus normal hyrax scan' do
      expect(scanner).not_to be_infected
    end
  end
end
