class ProductsController < ApplicationController
    def scrape
      url = params[:url]
      ScrapeProductJob.perform_later(url)
  
      redirect_to products_path, notice: "Scraping in progress. The product will appear shortly."
      
    end
  
    def index
      @query = params[:query]
      if @query.present?
        @products = Product.where("title ILIKE ?", "%#{@query}%") 
        @categories = Category.includes(:products).where(products: { id: @products }) 
      else
        @products = Product.all
        @categories = Category.includes(:products) 
      end
  
      respond_to do |format|
          format.html # Render full HTML page for non-AJAX requests
          format.js   # Render partial for AJAX requests
      end
    end
  end
  