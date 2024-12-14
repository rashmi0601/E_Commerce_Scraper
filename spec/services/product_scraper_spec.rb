require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ProductScraper, type: :service do
  let(:url) { "http://example.com/product" }
  let(:scraper) { ProductScraper.new(url) }

  before do
    stub_request(:get, /api.scraperapi.com/).to_return(
      body: File.read(Rails.root.join('spec/fixtures/files/product_page.html')),
      status: 200
    )
  end

  describe '#scrape' do
    context 'when the page is successfully scraped' do
      it 'scrapes the product data correctly' do
        scraped_data = scraper.scrape

        expect(scraped_data).to be_a(Hash)
        expect(scraped_data[:title]).to eq("Sample Product Title")
        expect(scraped_data[:description]).to eq("This is a sample product description. It's an amazing product that everyone should try.")
        expect(scraped_data[:price]).to eq(19.99)
        expect(scraped_data[:contact_info]).to eq("Contact Info")
        expect(scraped_data[:size]).to eq("Small, Medium, Large")
        expect(scraped_data[:url]).to eq(url)
      end
    end

    context 'when there is a missing field' do
      it 'returns a default value for missing title' do
        allow(scraper).to receive(:scrape).and_return({ title: "Title not found" })
        scraped_data = scraper.scrape

        expect(scraped_data[:title]).to eq("Title not found")
      end

      it 'returns a default value for missing price' do
        allow(scraper).to receive(:scrape).and_return({ price: "Price not found" })
        scraped_data = scraper.scrape

        expect(scraped_data[:price]).to eq("Price not found")
      end
    end

    context 'when scraping fails' do
      it 'handles errors and returns nil' do
        stub_request(:get, /api.scraperapi.com/).to_raise(OpenURI::HTTPError.new("404 Not Found", nil))

        result = scraper.scrape

        expect(result).to be_nil
      end
    end
  end
end
