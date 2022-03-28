# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.application.config.application_url

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  #
  def build_each_doc(doc)
    key = doc.fetch('has_model_ssim', []).first.constantize.model_name.singular_route_key
    loc = Rails.application.routes.url_helpers.send(key + "_url", doc['id'], only_path: true)
    date = doc.fetch('date_modified_dtsi', '') || doc.fetch('date_uploaded_dtsi', '')
    return loc, date
  end

  def public_work
    { workflow_state_name_ssim: "deposited", read_access_group_ssim: "public" }
  end

  Publication.search_in_batches(public_work) do |doc_set|
    doc_set.each do |doc|
      loc, date = build_each_doc(doc)
      add loc, :lastmod => date
    end
  end

  Dataset.search_in_batches(public_work) do |doc_set|
    doc_set.each do |doc|
      loc, date = build_each_doc(doc)
      add loc, :lastmod => date
    end
  end
end
