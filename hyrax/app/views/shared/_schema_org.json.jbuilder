json.set! :@context, 'http://schema.org/'
json.set! :@type, @presenter.resource_type.first
json.name @presenter.title.first
json.alternateName @presenter.alternate_title if @presenter.alternate_title
json.url main_app.polymorphic_url(@presenter)
json.identifier @presenter.doi if @presenter.doi.present?
json.license @presenter.rights_statement.first
json.description @presenter.description.first
json.keywords @presenter.keyword
