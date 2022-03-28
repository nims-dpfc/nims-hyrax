# override - hyrax-2.4.1
require 'json'
module Hyrax
  module CitationsBehaviors
    module PublicationBehavior
      include Hyrax::CitationsBehaviors::CommonBehavior

      # nims override to add doi
      def setup_doi(presenter)
        ci = presenter.complex_identifier
        if presenter.complex_identifier.is_a?(Array)
          ci = presenter.complex_identifier.first
        end
        JSON.parse(ci).
            select{|i| i["scheme"].any?{|s| s =~/doi/i} }.
            pluck('identifier').
            flatten.
            sort.
            join('. ')
      rescue JSON::ParserError # catch dodgy json
        nil
      end

      # @param [Hyrax::PublicationPresenter] presenter
      # nims override to retrieve place
      def setup_pub_place(presenter)
        return '' unless presenter.respond_to?(:place)
        return '' if presenter.place.blank?
        # place is a singular property, but returns here as an array (?)
        presenter.place.is_a?(String) ? presenter.place : presenter.place&.first
      end

      def setup_pub_publisher(presenter)
        presenter.publisher&.first
      end

      def setup_pub_info(presenter, include_date = false)
        pub_info = ""
        if (place = setup_pub_place(presenter))
          pub_info << CGI.escapeHTML(place)
        end
        if (publisher = setup_pub_publisher(presenter))
          pub_info << ": " << CGI.escapeHTML(publisher)
        end

        pub_year = begin
                    Date.parse(presenter.date_published.first).year
                   rescue Date::Error, TypeError
                    nil
                   end
        pub_info << ", " << pub_year.to_s unless pub_year.nil?
        # nims override to add doi
        pub_doi = setup_doi(presenter)
        pub_info << ". " << pub_doi unless pub_doi.nil?
        # end nims override to add doi
        pub_info.strip!
        pub_info.blank? ? nil : pub_info
      end

      def setup_pub_source(presenter)
        return unless presenter.respond_to?(:complex_source)
        return if presenter.complex_source.empty?
        cs = presenter.complex_source
        if presenter.complex_source.is_a?(Array)
          cs = presenter.complex_source.first
        end
        sources = JSON.parse(cs)
        return if sources.blank?
        pub_sources = []

        sources.each do |source|
          pub_source = ''

          if source['title'].present?
            pub_source << source['title'].first
            pub_source << '. '
          end

          if source['volume'].present?
            pub_source << source['volume'].first
            pub_source << ', '
          end

          if source['issue'].present?
            pub_source << 'no. '
            pub_source << source['issue'].first
            pub_source << '. '
          end

          if source['sequence_number'].present?
            pub_source << source['sequence_number'].first
            pub_source << '. '
          end

          pub_sources << pub_source.strip unless pub_source.blank?

        end
        pub_sources.join(', ')
      end

      def setup_pub_page(presenter)
        return unless presenter.respond_to?(:complex_source)
        return if presenter.complex_source.empty?
        cs = presenter.complex_source
        if presenter.complex_source.is_a?(Array)
          cs = presenter.complex_source.first
        end
        source = JSON.parse(cs).first
        return if source.blank?

        pub_page = ''
        if source['start_page'].present? && source['end_page'].present?
          pub_page << "#{source['start_page'].first}-#{source['end_page'].first}"
          pub_page << '. '
        end

        pub_page.blank? ? nil : pub_page.strip
      end

      def setup_pub_citation_info(presenter)
        return unless presenter.respond_to?(:complex_source)
        return if presenter.complex_source.empty?
        cs = presenter.complex_source
        if presenter.complex_source.is_a?(Array)
          cs = presenter.complex_source.first
        end
        sources = JSON.parse(cs)
        return if sources.blank?

        pub_sources = []

        sources.each do |source|
          pub_source = {}

          if source['title'].present? && source['title'].first.present?
            pub_source[:title] = source['title'].first.strip
          end

          if source['volume'].present? && source['volume'].first.present?
            pub_source[:volume] = source['volume'].first.strip
          end

          if source['issue'].present? && source['issue'].first.present?
            pub_source[:issue] = source['issue'].first.strip
          end

          if source['start_page'].present? && source['start_page'].first.present?
            pub_source[:start_page] = source['start_page'].first.strip
          end

          if source['end_page'].present? && source['end_page'].first.present?
            pub_source[:end_page] = source['end_page'].first.strip
          end
          pub_source
          pub_sources << pub_source unless pub_source.blank?

        end
        pub_sources.blank? ? nil : pub_sources.first
      end

      def setup_pub_year(presenter)
        return if presenter.date_published.blank?

        Date.parse(presenter.date_published.first).year
      rescue ArgumentError
        presenter.date_published.first
      end

      def google_scholar_pub_date(presenter)
        return if presenter.date_published.blank?

        Date.parse(presenter.date_published.first).strftime("%Y/%m/%d")
      rescue ArgumentError
        presenter.date_published.first
      end
    end
  end
end
