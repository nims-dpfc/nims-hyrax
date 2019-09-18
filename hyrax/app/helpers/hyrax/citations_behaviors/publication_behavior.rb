module Hyrax
  module CitationsBehaviors
    module PublicationBehavior
      include Hyrax::CitationsBehaviors::CommonBehavior

      # nims override to add doi
      def setup_doi(work)
        # join and split at } to give us an array of identifiers
        # this is a bit hacky, but it works
        identifiers = work.complex_identifier.join('}').split('}')
        # extract only dois
        dois = identifiers.select {|i| i.include?('DOI')}
        # pattern match to extract the doi
        "#{dois.map {|d| d.gsub(/(.*)identifier\":\["/, '').gsub(/"\],"scheme":\["DOI"(.*)/, '')}.join('. ')}"
      end

      # nims override to retrieve nested properties
      def setup_pub_date(work)
        first_date = CGI.escapeHTML(work.solr_document['complex_date_published_ssm'].first) 
        if first_date.present?
          first_date = CGI.escapeHTML(first_date)
          date_value = first_date.gsub(/[^0-9|n\.d\.]/, "")
          date_value = date_value.reverse[0, 4].reverse unless date_value.nil?
          return nil if date_value.nil?
        end
        clean_end_punctuation(date_value) if date_value
      end

      # @param [Hyrax::WorkShowPresenter] work_presenter
      # nims override to retrieve place
      def setup_pub_place(work_presenter)
        # unclear whether place is a single value or multi-value
        work_presenter.place.is_a?(String) ? work_presenter.place : work_presenter.place&.first
      end

      def setup_pub_publisher(work)
        work.publisher&.first
      end

      def setup_pub_info(work, include_date = false)
        pub_info = ""
        if (place = setup_pub_place(work))
          pub_info << CGI.escapeHTML(place)
        end
        if (publisher = setup_pub_publisher(work))
          pub_info << ": " << CGI.escapeHTML(publisher)
        end

        pub_date = include_date ? setup_pub_date(work) : nil
        pub_info << ", " << pub_date unless pub_date.nil?
        # nims override to add doi
        pub_doi = setup_doi(work)
        pub_info << ". " << pub_doi unless pub_doi.nil?
        # end nims override to add doi
        pub_info.strip!
        pub_info.blank? ? nil : pub_info
      end
    end
  end
end