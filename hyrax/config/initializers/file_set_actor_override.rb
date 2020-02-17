# Override Hyrax 2.6 to support Japanese characters in filenames
# Use Addressable::URI.unencode rather than Addressable::URI.parse
# PR to Hyrax 3.x https://github.com/samvera/hyrax/pull/4172
Hyrax::Actors::FileSetActor.class_eval do
  def label_for(file)
    if file.is_a?(Hyrax::UploadedFile) # filename not present for uncached remote file!
      file.uploader.filename.present? ? file.uploader.filename : File.basename(Addressable::URI.unencode(file.file_url))
    elsif file.respond_to?(:original_name) # e.g. Hydra::Derivatives::IoDecorator
      file.original_name
    elsif file_set.import_url.present?
      # This path is taken when file is a Tempfile (e.g. from ImportUrlJob)
      File.basename(Addressable::URI.unencode(file.file_url))
    else
      File.basename(file)
    end
  end
end