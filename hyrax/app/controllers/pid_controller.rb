class PidController < ApplicationController
  def show
    if params[:identifier] =~ /\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-z]{3}-[0-9a-z]{4}-[0-9a-f]{12}\z/
      data = Publication.where(identifier: params[:identifier]).first || Dataset.where(identifier: params[:identifier]).first

      case data&.class.to_s
      when 'Publication'
        redirect_to hyrax_publication_url(data)
        return
      when 'Dataset'
        redirect_to hyrax_dataset_url(data)
        return
      end
    end

    render file: Rails.root.join('public/404.html'), status: 404, layout: false
  end
end
