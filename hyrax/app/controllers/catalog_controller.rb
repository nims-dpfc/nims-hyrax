class CatalogController < ApplicationController
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior
  include BlacklightOaiProvider::CatalogControllerBehavior
  include Nims::BlacklightHelper

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  def self.uploaded_field
    solr_name('system_create', :stored_sortable, type: :date)
  end

  def self.modified_field
    solr_name('system_modified', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    config.http_method = :post

    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = Hyrax::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = [:index_header, :index]
    config.view.slideshow.partials = [:index]

    config.oai = OAI_CONFIG

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: "search",
      rows: 10,
      qf: "title_tesim description_tesim creator_tesim keyword_tesim"
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name("title", :stored_searchable)
    config.index.display_type_field = solr_name("has_model", :symbol)
    config.index.thumbnail_field = 'thumbnail_path_ss'


    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display

    facet_fields = (DatasetIndexer.facet_fields +
                   PublicationIndexer.facet_fields
                   ).uniq
    facet_fields.each do |fld|
      config.add_facet_field fld, limit: 5
    end
    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name('generic_type', :facetable), if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name('title', :stored_searchable), label: 'Title', itemprop: 'name', if: false
    config.add_index_field solr_name('description', :stored_searchable), itemprop: 'description', helper_method: :render_truncated_description, if: lambda { |context, field_config, document| context.can?(:read_abstract, document.hydra_model) }
    config.add_index_field solr_name('keyword', :stored_searchable), itemprop: 'keywords', link_to_search: solr_name('keyword', :facetable), if: lambda { |context, field_config, document| context.can?(:read_keyword, document.hydra_model) }
    # config.add_index_field solr_name('complex_specimen_type', :stored_searchable), itemprop: 'specimen'
    config.add_index_field solr_name('specimen_set', :stored_searchable), itemprop: 'specimen'
    config.add_index_field solr_name('subject', :stored_searchable), itemprop: 'about', link_to_search: solr_name('subject', :facetable), if: lambda { |context, field_config, document| context.can?(:read_subject, document.hydra_model) }
    config.add_index_field solr_name('resource_type', :stored_searchable), label: 'Resource Type', link_to_search: solr_name('resource_type', :facetable), if: lambda { |context, field_config, document| context.can?(:read_resource_type, document.hydra_model) }
    config.add_index_field solr_name('data_origin', :stored_searchable), itemprop: 'data_origin', link_to_search: solr_name('data_origin', :facetable)

    # config.add_index_field solr_name('creator', :stored_searchable), itemprop: 'creator', link_to_search: solr_name('creator', :facetable)
    # config.add_index_field solr_name('contributor', :stored_searchable), itemprop: 'contributor', link_to_search: solr_name('contributor', :facetable)
    config.add_index_field solr_name('complex_person_author', :stored_searchable), itemprop: 'author', link_to_search: solr_name('complex_person_author', :facetable)
    # config.add_index_field solr_name('complex_person_editor', :stored_searchable), itemprop: 'editor', link_to_search: solr_name('complex_person_editor', :facetable)
    # config.add_index_field solr_name('complex_person_translator', :stored_searchable), itemprop: 'translator', link_to_search: solr_name('complex_person_translator', :facetable)
    config.add_index_field solr_name('complex_person_data_depositor', :stored_searchable), itemprop: 'data depositor', link_to_search: solr_name('complex_person_data_depositor', :facetable)
    config.add_index_field solr_name('complex_person_data_curator', :stored_searchable), itemprop: 'data curator', link_to_search: solr_name('complex_person_data_curator', :facetable)
    config.add_index_field solr_name('complex_person_operator', :stored_searchable), itemprop: 'operator', link_to_search: solr_name('complex_person_operator', :facetable)
    config.add_index_field solr_name('complex_person_contact_person', :stored_searchable), itemprop: 'contact person', link_to_search: solr_name('complex_person_contact_person', :facetable)
    config.add_index_field solr_name('complex_person_other', :stored_searchable), itemprop: 'creator or contributor', link_to_search: solr_name('complex_person_other', :facetable)
    # config.add_index_field solr_name('proxy_depositor', :symbol), label: 'Depositor', helper_method: :link_to_profile
    #  config.add_index_field solr_name('depositor'), label: 'Owner', helper_method: :link_to_profile

    # config.add_index_field solr_name('publisher', :stored_searchable), itemprop: 'publisher', link_to_search: solr_name('publisher', :facetable)
    config.add_index_field solr_name('date_published', :stored_sortable, type: :date), itemprop: 'datePublished', helper_method: :human_readable_date

    # config.add_index_field solr_name('rights_statement', :stored_searchable), helper_method: :rights_statement_links, if: lambda { |context, field_config, document| context.can?(:read_rights, document.hydra_model) }
    config.add_index_field solr_name('license', :stored_searchable), helper_method: :license_links

    config.add_index_field solr_name('complex_source_title', :stored_searchable), itemprop: 'journal'

    config.add_index_field solr_name('date_uploaded', :stored_sortable, type: :date), itemprop: 'datePublished', helper_method: :human_readable_date
    config.add_index_field solr_name('date_modified', :stored_sortable, type: :date), itemprop: 'dateModified', helper_method: :human_readable_date
    config.add_index_field solr_name('date_created', :stored_searchable), itemprop: 'dateCreated'

    #config.add_index_field solr_name('file_format', :stored_searchable), link_to_search: solr_name('file_format', :facetable)
    #config.add_index_field solr_name('identifier', :stored_searchable), helper_method: :index_field_link, field_name: 'identifier'
    #config.add_index_field solr_name('embargo_release_date', :stored_sortable, type: :date), label: 'Embargo release date', helper_method: :human_readable_date
    #config.add_index_field solr_name('lease_expiration_date', :stored_sortable, type: :date), label: 'Lease expiration date', helper_method: :human_readable_date
    #config.add_index_field solr_name('place', :stored_searchable), itemprop: 'place', link_to_search: solr_name('place', :facetable)
    #config.add_index_field solr_name('status', :stored_searchable), itemprop: 'status', link_to_search: solr_name('status', :facetable)
    # config.add_index_field solr_name('issue', :stored_searchable), label: 'Issue'
    # config.add_index_field solr_name('based_near_label', :stored_searchable), itemprop: 'contentLocation', link_to_search: solr_name('based_near_label', :facetable)
    # config.add_index_field solr_name('language', :stored_searchable), itemprop: 'inLanguage', link_to_search: solr_name('language', :facetable)


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    show_fields = (DatasetIndexer.show_fields +
                   PublicationIndexer.show_fields
                   ).uniq
    show_fields.each do |fld|
      config.add_show_field fld
    end

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields') do |field|
      all_names = (DatasetIndexer.search_fields +
                   PublicationIndexer.search_fields
                   ).uniq.join(" ")
      title_name = solr_name("title", :stored_searchable)
      field.solr_parameters = {
        qf: "#{all_names} file_format_tesim all_text_timv",
        pf: title_name.to_s
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    config.add_search_field('complex_person') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = solr_name("complex_person", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = solr_name("title", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = "Abstract or Summary"
      solr_name = solr_name("description", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      solr_name = solr_name("publisher", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      solr_name = solr_name("created", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = solr_name("subject", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      solr_name = solr_name("language", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      solr_name = solr_name("resource_type", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      solr_name = solr_name("format", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = solr_name("id", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('keyword') do |field|
      solr_name = solr_name("keyword", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name("depositor", :symbol)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights_statement') do |field|
      solr_name = solr_name("rights_statement", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('license') do |field|
      solr_name = solr_name("license", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.show.document_actions = {}

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: "relevance"
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  # disable the bookmark control from displaying in gallery view
  # Hyrax doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end

  def show
    @response, @document = fetch params[:id]
    respond_to do |format|
      format.html { setup_next_and_previous_documents }
      format.json do
        @presenter = Blacklight::JsonPresenter.new(@response, @document, facets_from_request, blacklight_config)
      end
      additional_export_formats(@document, format)
    end
  end

  BlacklightOaiProvider::SolrDocumentProvider.register_format(Metadata::Jpcoar.instance)
end
