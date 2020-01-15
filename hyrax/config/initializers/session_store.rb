# Be sure to restart your server when you modify this file.

# NB the cookie session store is not compatible with single sign out - so we shall use a Redis-based session store instead (redis-session-store gem)
redis_config = YAML.safe_load(ERB.new(IO.read(Rails.root.join('config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
Rails.application.config.session_store :redis_session_store, {
    key: '_hyrax_session',
    redis: {
        expire_after: 90.minutes,  # cookie expiration
        ttl: 90.minutes,           # Redis expiration, defaults to 'expire_after'
        key_prefix: 'hyrax:session:',
        url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/0",
    }
}
