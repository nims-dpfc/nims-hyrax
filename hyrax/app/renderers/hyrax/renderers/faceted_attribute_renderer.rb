module Hyrax
  module Renderers
    class FacetedAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          link_to(value.html_safe, search_path(value.html_safe))
        end

        def search_path(value)
          Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value, locale: I18n.locale)
        end

        def search_field
          ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, field), :facetable, type: :string))
        end
    end
  end
end
