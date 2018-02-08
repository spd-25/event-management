# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_event-management_session'

if ENV['REDIS_SESSION_URL'].present?
  uri = URI(ENV['REDIS_SESSION_URL'])
  uri.password = Rails.application.secrets.em_redis_password

  Rails.application.config.session_store :redis_store, servers: [uri.to_s]
end
