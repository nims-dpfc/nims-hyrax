module Hyrax
  module CitationsBehaviors
    module PublicationBehavior
      include Hyrax::CitationsBehaviors::CommonBehavior
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
      # nims override to retrieve nested properties
      def setup_pub_place(work_presenter)
        work_presenter.place&.first
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

        pub_info.strip!
        pub_info.blank? ? nil : pub_info
      end
    end
  end
end