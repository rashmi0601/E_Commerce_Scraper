require 'sidekiq/cron/job'
Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379' } 
  end
  
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379' }
  end

  Sidekiq::Cron::Job.create(
  name: 'Update old products - daily',
  cron: '0 0 * * *',  # Cron format: 0 0 * * * means once a day at midnight
  class: 'ProductUpdateWorker'
)