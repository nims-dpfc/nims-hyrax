class RecreateDerivativesService
  # Service to create derivatives (thumbnails for all pdf and doc files)
  def self.generate_all
    ::FileSet.find_each do |file_set|
      if ::FileSet.pdf_mime_types.include?(file_set.mime_type) or ::FileSet.office_document_mime_types.include?(file_set.mime_type)
        file_set.files do |f|
          ::CreateDerivativesJob.perform_later(file_set, f.id)
        end
      end
    end
  end
end