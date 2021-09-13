# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

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
  Publication.all.each do |publication|
    next unless publication.visibility == 'open'
    next unless publication.state.id == 'http://fedora.info/definitions/1/0/access/ObjState#active'

    add polymorphic_path(publication), :lastmod => publication.date_modified || publication.date_uploaded
  end

  Dataset.all.each do |dataset|
    next unless publication.visibility == 'open'
    next unless publication.state.id == 'http://fedora.info/definitions/1/0/access/ObjState#active'

    add polymorphic_path(dataset), :lastmod => dataset.date_modified || dataset.date_uploaded
  end
end
