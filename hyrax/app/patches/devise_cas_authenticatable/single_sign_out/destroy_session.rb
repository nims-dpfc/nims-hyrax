# Monkey Patch to DeviseCasAuthenticatable::SingleSignOut::DestroySession#destroy_session_by_id to fix env issue

module DeviseCasAuthenticatable
  module SingleSignOut
    module DestroySession
      def destroy_session_by_id(sid)
        logger.debug "Single Sign Out from session store: #{current_session_store.class}"
        if session_store_class.name =~ /RedisSessionStore/
          current_session_store.send(:destroy_session, {}, sid, drop: true)
          true
        else
          logger.error "Unsupported session store: #{session_store_class.name}"
          false
        end
      end
    end
  end
end
