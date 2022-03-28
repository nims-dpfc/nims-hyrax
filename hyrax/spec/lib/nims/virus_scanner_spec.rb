require 'rails_helper'
require 'fileutils'
require 'tempfile'
require 'pathname'

# Check for github actions runner when setting file path
# Github actions needs a different path than the local vm
RSpec.describe Nims::VirusScanner do
  subject(:scanner) { described_class.new(file) }

  before(:suite) do
    if !Dir.exist?('/shared/uploads/runner')
      FileUtils.mkdir_p('/shared/uploads/runner')
    end
  end
  after(:suite) do
    FileUtils.rm_r('/shared/uploads/runner/*')
    FileUtils.rmdir '/shared/uploads/runner'
  end

  context 'when a file is not infected' do
    src_path = Pathname.new('spec/fixtures/files/test.txt').realpath.to_s
    let(:file) { '/shared/uploads/runner/text.txt' }

    before do
      FileUtils.cp(src_path, file)
    end

    it 'does not have a virus hy-c custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::SuccessResponse
    end

    it 'does not have a virus normal hyrax scan' do
      expect(scanner).not_to be_infected
    end
  end

  context 'when it cannot find the file' do
    let(:file) { 'not/a/file.txt' }

    it 'raises an error' do
      expect { scanner.infected? }.to raise_error(ClamAV::Util::UnknownPathException)
    end
  end

  context 'when a file is infected' do
    src_path = Pathname.new('spec/fixtures/files/virus.txt').realpath.to_s
    let(:file) { '/shared/uploads/runner/virus.txt' }

    before do
      FileUtils.cp(src_path, file)
    end

    it 'has a virus nims custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::VirusResponse
    end

    it 'has a virus nims normal hyrax scan' do
      expect(scanner).to be_infected
    end
  end

  context 'when a file name has special characters' do
    src_path = Pathname.new('spec/fixtures/files/odd_chars_+.txt').realpath.to_s
    let(:file) { '/shared/uploads/runner/odd_chars_+.txt' }

    before do
      FileUtils.cp(src_path, file)
    end

    it 'can perform a nims custom scan' do
      expect(scanner.scan_file).to be_a ClamAV::SuccessResponse
    end

    it 'does not have a virus normal hyrax scan' do
      expect(scanner).not_to be_infected
    end
  end
end
