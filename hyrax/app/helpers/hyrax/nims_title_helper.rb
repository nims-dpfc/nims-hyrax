module Hyrax::NimsTitleHelper
  def application_name_full
    t('hyrax.product_name_full')
  end
end

module Hyrax::TitleHelper
  include Hyrax::NimsTitleHelper
end
