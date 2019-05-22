module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def available_translations
    {
      # 'de' => 'Deutsch',
      'en' => 'English',
      # 'es' => 'Español',
      # 'fr' => 'Français',
      # 'it' => 'Italiano',
      # 'pt-BR' => 'Português do Brasil',
      # 'zh' => '中文'
    }
  end
end
