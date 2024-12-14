require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    let!(:category) { create(:category) }
    let!(:product1) { create(:product, title: "Laptop", category: category) }
    let!(:product2) { create(:product, title: "Phone", category: category) }

    context "when a query is provided" do
      it "assigns products matching the query to @products" do
        get :index, params: { query: "Laptop" }
        expect(assigns(:products)).to eq([product1])
      end

      it "assigns the related categories to @categories" do
        get :index, params: { query: "Laptop" }
        expect(assigns(:categories)).to include(category)
      end
    end

    context "when no query is provided" do
      it "assigns all categories with their products to @categories" do
        get :index
        expect(assigns(:categories)).to include(category)
      end
    end    
  end

  describe "POST #scrape" do
    context "when the URL is provided" do
      it "enqueues the ScrapeProductJob" do
        expect {
          post :scrape, params: { url: "https://example.com/product" }
        }.to have_enqueued_job(ScrapeProductJob).with("https://example.com/product")
      end

      it "redirects to products_path with a success notice" do
        post :scrape, params: { url: "https://example.com/product" }
        expect(response).to redirect_to(products_path)
        expect(flash[:notice]).to eq("Scraping in progress. The product will appear shortly.")
      end
    end

    context "when the URL is not provided" do
      it "redirects to products_path with an alert message" do
        post :scrape, params: { url: "" }
        expect(response).to redirect_to(products_path)
        expect(flash[:alert]).to eq("Please provide a valid product URL.")
      end
    end
  end
end
