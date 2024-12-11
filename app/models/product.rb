class Product < ApplicationRecord
  belongs_to :category
  validates :title, presence: true

  def self.update_old_products
    where('scraped_at < ?', 1.week.ago).find_each do |product|
      ProductUpdateJob.perform_async(product.id) 
    end
  end
end
