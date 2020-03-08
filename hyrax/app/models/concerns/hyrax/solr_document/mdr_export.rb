module Hyrax
  module SolrDocument
    module MdrExport
      def persistent_url(host: nil)
        if host.present?
          Rails.application.routes.url_helpers.polymorphic_url(self, host: host)
        else
          Rails.application.routes.url_helpers.polymorphic_url(self)
        end
      end
    end
  end
end
