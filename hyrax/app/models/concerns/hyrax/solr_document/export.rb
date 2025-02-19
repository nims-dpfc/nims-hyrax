module Hyrax
  module SolrDocument
    module Export
      # MIME: 'application/x-endnote-refer'
      def export_as_endnote
        text = []
        text << "%0 #{human_readable_type}"
        end_note_format.each do |endnote_key, mapping|
          if mapping.is_a? String
            values = [mapping]
          else
            values = send(mapping[0]) if respond_to? mapping[0]
            values = mapping[1].call(values) if mapping.length == 2
            values = Array.wrap(values)
          end
          next if values.blank? || values.first.nil?
          spaced_values = values.join("; ")
          text << "#{endnote_key} #{spaced_values}"
        end
        text.join("\n")
      end

      # Name of the downloaded endnote file
      # Override this if you want to use a different name
      def endnote_filename
        "#{id}.endnote"
      end

      def persistent_url
        "#{Hyrax.config.persistent_hostpath}#{id}"
      end

      def end_note_format
        {
          '%T' => [:title],
          # '%Q' => [:title, ->(x) { x.drop(1) }], # subtitles
          '%A' => [:creator],
          '%C' => [:publication_place],
          '%D' => [:date_created],
          '%8' => [:date_uploaded],
          '%E' => [:contributor],
          '%I' => [:publisher],
          '%J' => [:series_title],
          '%@' => [:isbn],
          '%U' => [:persistent_url],
          '%7' => [:edition_statement],
          '%R' => [:doi],
          '%(' => [:first_published_url],
          '%X' => [:description],
          '%G' => [:language],
          '%[' => [:date_modified],
          '%9' => [:resource_type],
          '%K' => [:keyword],
          '%~' => I18n.t('hyrax.product_name_full'),
          '%W' => Institution.name_full
        }
      end

      # MIME: 'application/x-bibtex'
      def export_as_bibtex
        text = []
        if human_readable_type == "Publication"
          text << "@Article{#{id}"
          bibtex_format = bibtex_publication_format
        else
          text << "@misc{#{id}"
          bibtex_format = bibtex_dataset_format
        end
        bibtex_format.each do |bibtex_key, mapping|
          if mapping.is_a? String
            values = [mapping]
          else
            values = send(mapping[0]) if respond_to? mapping[0]
            values = mapping[1].call(values) if mapping.length == 2
            values = Array.wrap(values)
          end
          next if values.blank? || values.first.nil?
          spaced_values = values.join("; ")
          text << "#{bibtex_key.ljust(12)} = #{spaced_values}"
        end
        text << "}"
        text.join(",\n")
      end

      # Name of the downloaded bibtex file
      def bibtex_filename
        "#{id}.bibtex"
      end

      def bibtex_publication_format
        {
          'author' => [:creator],
          'title'  => [:title],
          'year' => bibtex_year,
          'pages' => [:total_number_of_pages],
          'month' => bibtex_month,
          'annote' => [:description],
          'howpublished' => [:persistent_url],
          'doi' => [:doi],
          'isbn' => [:isbn],
          'edition' => [:edition_statement],
          'institution' => Institution.name_full
        }
      end

      def bibtex_dataset_format
        {
          'author' => [:creator],
          'title'  => [:title],
          'year' => bibtex_year,
          'month' => bibtex_month,
          'version' => [:complex_version],
          'doi' => [:doi],
          'type' => 'Dataset',
          'annote' => [:description],
          'howpublished' => [:persistent_url],
          'institution' => Institution.name_full
        }
      end

      def bibtex_year
        begin
          if date_published.present?
            DateTime.parse(date_published[0]).strftime('%Y')
          elsif date_created.present?
            DateTime.parse(date_created[0]).strftime('%Y')
          else
            ''
          end
        rescue
          date_published.present? ? date_published.first : ''
        end
      end

      def bibtex_month
        begin
          if date_published.present?
            DateTime.parse(date_published[0]).strftime('%m')
          elsif date_created.present?
            DateTime.parse(date_created[0]).strftime('%m')
          else
            ''
          end
        rescue
          ''
        end
      end
    end
  end
end
