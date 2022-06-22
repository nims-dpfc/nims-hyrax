module Hyrax
  module Renderers
    class FacetedAttributeRenderer < AttributeRenderer
      private

        def li_value(value)
          safe_value = ERB::Util.h(value)
          if safe_value.include?("&amp;")
            safe_value = safe_value.gsub("&amp;", "&")
          end
          link_to(safe_value, search_path(safe_value))
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
