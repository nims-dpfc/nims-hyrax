class LocalTermsController < ApplicationController
  def index
    result =  ActiveFedora::SolrService.get('*:*', rows: 0, facet: 'on', 'facet.field' => params[:field], 'facet.limit' => -1)
    terms = result['facet_counts']['facet_fields'][params[:field]].reject { |a| a.is_a?(Integer) }
    if params[:q] && params[:q].size > 0
      terms.select! { |a| a.downcase.match(params[:q].downcase) }
    end
    render json: terms
  end
end
