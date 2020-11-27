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

      # nims override to retrieve nested properties
      def setup_pub_date(presenter)
        pub_date = presenter.solr_document['complex_date_published_ssm'].try(:first)
        return nil if pub_date.nil?
        first_date = CGI.escapeHTML(pub_date)
        if first_date.present?
          first_date = CGI.escapeHTML(first_date)
          date_value = first_date.gsub(/[^0-9|n\.d\.]/, "")
          date_value = date_value.reverse[0, 4].reverse unless date_value.nil?
          return nil if date_value.nil?
        end
        clean_end_punctuation(date_value) if date_value
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

        pub_date = include_date ? setup_pub_date(presenter) : nil
        pub_info << ", " << pub_date unless pub_date.nil?
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
        source = JSON.parse(cs).first
        return if source.blank?

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

        pub_source.blank? ? nil : pub_source.strip
      end

      def setup_pub_page(presenter)
        return if presenter.complex_source.empty?
        cs = presenter.complex_source
        if presenter.complex_source.is_a?(Array)
          cs = presenter.complex_source.first
        end
        source = JSON.parse(cs).first
        pub_page = ''

        if source['start_page'].present? && source['end_page'].present?
          pub_page << "#{source['start_page'].first}-#{source['end_page'].first}"
          pub_page << '. '
        end

        pub_page.blank? ? nil : pub_page.strip
      end
    end
  end
end
