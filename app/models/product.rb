class Product < ApplicationRecord
  belongs_to :category
  validates :title, presence: true

  def self.update_old_products
    products_to_update = Product.where("last_scraped_at < ?", 1.week.ago)    
    products_to_update.find_each do |product|
      ScrapeProductJob.perform_later(product.id, product.url)     
      product.update(last_scraped_at: Time.current)
    end
  end
end
