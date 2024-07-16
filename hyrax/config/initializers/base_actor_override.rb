Hyrax::Actors::BaseActor.class_eval do
  # @param [Hyrax::Actors::Environment] env
  # @return [Boolean] true if update was successful
  def update(env)
    apply_update_data_to_curation_concern(env)
    apply_save_data_to_curation_concern(env)
    next_actor.update(env) && save(env) && run_callbacks(:after_create_concern, env)
  end
end