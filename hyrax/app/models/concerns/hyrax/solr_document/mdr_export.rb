module Hyrax
  module SolrDocument
    module MdrExport
      def persistent_url
        Rails.application.routes.url_helpers.polymorphic_url(self)
      end
    end
  end
end
