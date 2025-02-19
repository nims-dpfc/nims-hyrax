# Make the base URL suffix of the external matomo instance configurable.
# This is required because
# a) by default, Faraday does not follow HTTP redirects, and
# b) the code in the Hyrax 3.5.0 code doesn't work if the Matomo instance's webserver redirects / to /index.php
# See also https://github.com/samvera/hyrax/issues/5593 and https://github.com/samvera/hyrax/issues/5846
if Hyrax.config.analytics
  Rails.configuration.to_prepare do
    Hyrax::Analytics::Matomo.module_eval do
      class_methods do
        # Format Data Range "2021-01-01,2021-01-31"
        def default_date_range
          "#{Hyrax.config.analytics_start_date},#{Time.zone.today.strftime("%Y-%m-%d")}"
        end
  
        def api_params(method, period, date, additional_params = {})
          date = date.split(',').map{ |d| d.to_date.strftime("%Y-%m-%d")}.join(',')
          params = {
            module: "API",
            idSite: config.site_id,
            method: method,
            period: period,
            date: date,
            format: "JSON",
            token_auth: config.auth_token
          }
          params.merge!(additional_params)
          get(params)
        end
  
        def get(params)
          base_url = config.base_url
          base_url = base_url + '/' unless base_url.end_with?('/')
          response = Faraday.get(base_url+ENV.fetch("MATOMO_BASE_URL_SUFFIX","index.php"), params)
          return [] if response.status != 200
          JSON.parse(response.body)
        end
      end
    end
  end
end

