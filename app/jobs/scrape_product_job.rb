class ScrapeProductJob < ApplicationJob
  queue_as :default

  def perform(url)
    scraper = ProductScraper.new(url)
    data = scraper.scrape
    category = Category.find_or_create_by(name: data[:category_name])
    Product.create!(
      title: data[:title],
      description: data[:description],
      price: data[:price],
      contact_info: data[:contact_info],
      size: data[:size],
      category: category,
      last_scraped_at: Time.current
    )
  rescue => e
    Rails.logger.error "Scraping failed for URL #{url}: #{e.message}"
  end
end
