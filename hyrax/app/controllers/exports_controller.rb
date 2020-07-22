require 'csv'
require 'json'

class ExportsController < Hyrax::DownloadsController
  MAXIMUM_ROWS = 100

  def export
    if file.present? && file.mime_type.present? && (file.mime_type =~ /^(?:text|application)\/csv$/i || file.mime_type =~ /^(?:text|application)\/tab-separated-values$/i)
      render json: csv_as_datatable
    else
      render :json => { error: 'Unknown or unsupported file type' }, :status => :bad_request
    end
  end

  private

  def csv_as_datatable
    # CSV files come in many different flavours (character encodings), e.g. ASCII-8BIT, UTF-8, ISO-8859-1 or Windows-1252.
    # It is not possible to detect the character encoding of a file with 100% accuracy. So we will assume files are in UTF-8
    # (as the world is moving that way) and scrub out any characters which do not conform to UTF-8. This "lossy" approach
    # should be ok as this export is merely used to provide a preview of the file, rather than the actual file itself.
    content = file.content.force_encoding(Encoding::UTF_8).scrub
    csv = file.mime_type =~ /^(?:text|application)\/tab-separated-values$/i ? CSV.parse(content, headers: true, col_sep: "\t", quote_char: "Ƃ") : CSV.parse(content, headers: true)
    csv =
    {
        columns: csv.headers,
        data: csv.take(MAXIMUM_ROWS).map(&:values_at),
        total_rows: csv.size,
        maximum_rows: MAXIMUM_ROWS,
        file_name: file_name
    }
  end
end
