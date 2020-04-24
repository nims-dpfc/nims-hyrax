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
  
  # Gather file_sets ids available to the requesting user
  def available_file_set_ids(presenter, ability)
    presenter.file_set_presenters.select do |p|
      ability.can?(:read, p.id)
    end.collect(&:id)
  end

  def within_file_size_threshold?(ids)
    total_size_file_sets(ids) > 0 && total_size_file_sets(ids) < max_size_file_sets
  end

  def total_size_file_sets(ids)
    @total_size_file_sets ||= file_sets(ids).map { |fs| fs['file_size_lts'] }.compact.inject(:+) || 0
  end

  def file_sets(ids)
    @file_sets ||= FileSet.search_with_conditions(id: ids)
  end

  # 100Mb
  def max_size_file_sets
    100_000_000
  end

end
