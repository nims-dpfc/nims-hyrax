class MdrExportWorkService
  attr_accessor :work, :mdr_metadata, :zip_dir, :zip_filepath

  class ExportException < StandardError
    def initialize(msg="MDR2 Export service Exception")
      super(msg)
    end
  end

  def initialize(work_id, export_dir)
    @work = ActiveFedora::Base.find(work_id)
    @work_dir = File.join(ENV.fetch('RAILS_TMP', '/tmp'), "#{@work.id}")
    if @work.class.to_s == 'Publication'
      @zip_dir = File.join(export_dir, 'publications')
    elsif @work.class.to_s == 'Dataset'
      @zip_dir = File.join(export_dir, 'datasets')
    else
      raise ExportException.new("#{work_id}: Class #{@work.class.to_s} not supported")
    end
    @zip_filepath = File.join(@zip_dir, "#{work.id}.zip"  )
    @metadata_filename = "enju_rdm_metadata.yml"
  end

  def build_zip
    mk_zip_file_dir
    add_metadata
    add_files
    create_zip_file
    cleanup
    File.exist?(@zip_filepath)
  end

  private

  def mk_zip_file_dir
    FileUtils.mkdir_p(@work_dir)
  end

  def add_metadata
    ms = MdrYamlService.new(@work)
    metadata = ms.yaml_metadata
    @mdr_metadata = ms.mdr_metadata
    filepath = File.join(@work_dir, @metadata_filename)
    File.write(
      filepath, metadata, mode: 'wb'
    )
  end

  def add_files
    @work.file_sets.each do |file_set|
      next if file_set.original_file.blank?
      file_set.original_file.tap do |file|
        filepath = File.join(@work_dir, CGI.unescape(file_set.original_file.file_name.first))
        File.open(filepath, 'wb') do |output|
          file.stream.each { |content| output.write(content) }
        end
      end
    end
  end

  def create_zip_file
    FileUtils.mkdir_p(@zip_dir)
    WillowSword::ZipPackage.new(@work_dir, @zip_filepath).create_zip
  end

  def cleanup
    FileUtils.rm_rf(@work_dir)
  end
end