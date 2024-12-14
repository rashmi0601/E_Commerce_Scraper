class ProductUpdateWorker
    include Sidekiq::Worker  
    def perform
      Product.update_old_products
    end
  end
  