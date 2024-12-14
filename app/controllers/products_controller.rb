class ProductsController < ApplicationController
  def scrape
    url = params[:url]
  
    if url.blank?
      redirect_to products_path, alert: "Please provide a valid product URL."
      return
    end
      
    begin
      ScrapeProductJob.perform_later(url)
  
      redirect_to products_path, notice: "Scraping in progress. The product will appear shortly."
      
    end
  end
  
  def index
    @query = params[:query]
  
    if @query.present?
      @products = Product.where("title ILIKE ?", "%#{@query}%")
      @categories = Category.includes(:products).where(products: { id: @products.pluck(:id) }).order('products.created_at DESC')
    else
      @categories = Category.joins(:products).order('products.created_at DESC').includes(:products)
    end
  
    respond_to do |format|
      format.html 
      format.js  
    end  
  end
  
end
  