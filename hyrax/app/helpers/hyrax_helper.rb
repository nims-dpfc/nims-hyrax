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

  def link_to_profile(args)
    user_or_key = args.is_a?(Hash) ? args[:value].first : args
    user = case user_or_key
           when User
             user_or_key
           when String
             ::User.find_by_user_key(user_or_key)
           end
    return user_or_key if user.nil?
    text = user.respond_to?(:name) ? user.name : user_or_key
    link_to text, Hyrax::Engine.routes.url_helpers.user_path(user.user_identifier)
  end
end
