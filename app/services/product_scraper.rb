require 'open-uri'
require 'nokogiri'

class ProductScraper
  SCRAPER_API_KEY = '8091b278d360aee09df33a1c08b2825b'

  def initialize(url)
    @url = url
    @selectors = load_selectors
  end

  def scrape
    scraperapi_url = "http://api.scraperapi.com?api_key=#{SCRAPER_API_KEY}&url=#{URI::DEFAULT_PARSER.escape(@url)}"
    puts "Scraping URL: #{scraperapi_url}"
  
    page = Nokogiri::HTML(URI.open(scraperapi_url))
 
    {
      title: page.css(@selectors[:title])&.text&.strip || "Title not found",
      description: page.css(@selectors[:description])&.text&.strip || "Description not found",
      price: page.css(@selectors[:price])&.text&.strip&.gsub(/[^\d.]/, '').to_f || "Price not found",
      contact_info: page.css(@selectors[:contact_info])&.text&.strip || "Contact info not found",
      size: extract_sizes(page) || "Size not found",
      category_name: extract_category_name(page) || "Category not found"
    }
  rescue OpenURI::HTTPError => e
    puts "Scraping failed for URL #{@url}: #{e.message}"
    nil
  end
  

  private

  def load_selectors
    {
      title: '.VU-ZEz',                       
      description: '.yN\+eNk.w9jEaj',        
      price: '.Nx9bqj.CxhGGd',               
      contact_info: '#sellerName.yeLeBC',     
      size: 'ul.hSEbzK li.aJWdJI.dpZEpc a.CDDksN.zmLe5G.dpZEpc',     
      category_name: '.r2CdBx'                
    }
  end

  def extract_sizes(page)
    sizes = page.css(@selectors[:size])
    sizes.map { |size| size.text.strip }.join(', ') if sizes.any?
  end

  def extract_category_name(page)
    category = page.css(@selectors[:category_name])
    second_div = category[1]
    if second_div
      anchor = second_div.css('a.R0cyWM').first 
      anchor.text.strip if anchor   
    else
      "Unknown"
    end
    
  end
end
