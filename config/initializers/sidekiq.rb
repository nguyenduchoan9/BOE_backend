require 'sidekiq/api'
Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
        # chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 0
    end
    config.redis = { db: 1 }
end

Sidekiq.configure_client do |config|
    config.redis = { db: 1 }
end
