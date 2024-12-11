class ProductsController < ApplicationController
    def scrape
      url = params[:url]
      ScrapeProductJob.perform_later(url)
  
      redirect_to products_path, notice: "Scraping in progress. The product will appear shortly."
      
    end
  
    def index
      @categories = if params[:query].present?
                      Category.joins(:products)
                              .where("products.title ILIKE ?", "%#{params[:query]}%")
                              .distinct
                    else
                      Category.includes(:products)
                    end
    end
  end
  