require 'rails_helper'

RSpec.describe ScrapeProductJob, type: :job do
  let(:product) { create(:product) } 
  let(:url) { "https://example.com/product" }
  let(:scraped_data) do
    {
      title: "Product Title",
      description: "Product Description",
      price: 99.99,
      contact_info: "Contact Info",
      size: "Large",
      category_name: "Category Name",
      url: url
    }
  end

  before do
    allow(ProductScraper).to receive(:new).and_return(double(scrape: scraped_data))
  end

  describe "#perform" do
    context "when product_id is provided" do
      it "updates the product with scraped data" do
        product = create(:product, url: url)

        expect {
          ScrapeProductJob.perform_now(product.id, url)
        }.to change { product.reload.title }.to("Product Title")
          .and change { product.reload.description }.to("Product Description")
          .and change { product.reload.price }.to(99.99)
          .and change { product.reload.contact_info }.to("Contact Info")
      end
    end

    context "when product_id is not provided" do
      it "creates a new product with the scraped data" do
        expect {
          ScrapeProductJob.perform_now(nil, url)
        }.to change(Product, :count).by(1)
      end
    end
  end
end
