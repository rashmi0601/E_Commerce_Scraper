class ScrapeProductJob < ApplicationJob
  queue_as :default

  def perform(product_id = nil, url)
    scraper = ProductScraper.new(url)
    data = scraper.scrape
    category = Category.find_or_create_by(name: data[:category_name])
  
    product = if product_id
                Product.find_by(id: product_id)
              else
                Product.find_or_initialize_by(url: data[:url])
              end
  
    if product
      product.update!(
        title: data[:title],
        description: data[:description],
        price: data[:price],
        contact_info: data[:contact_info],
        size: data[:size],
        category: category,
        last_scraped_at: Time.current
      )
    else
      Rails.logger.error "Product not found for ID #{product_id} and URL #{url}"
    end  
  rescue => e
    Rails.logger.error "Scraping failed for URL #{url}: #{e.message}"
  end
end
 