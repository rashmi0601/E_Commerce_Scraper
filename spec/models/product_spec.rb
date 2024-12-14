require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe Product, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'associations' do
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe ".update_old_products" do
    let!(:category) { create(:category) }
    let!(:product_old) { create(:product, category: category, last_scraped_at: 2.weeks.ago) }
    let!(:product_recent) { create(:product, category: category, last_scraped_at: 2.days.ago) }

    it "updates the last_scraped_at timestamp for old products" do
      travel_to Time.zone.now do
        Product.update_old_products
        expect(product_old.reload.last_scraped_at).to be_within(1.second).of(Time.current)
      end
    end

    it "does not update the last_scraped_at timestamp for recent products" do
      previous_time = product_recent.last_scraped_at
      travel_to Time.zone.now do
        Product.update_old_products
        expect(product_recent.reload.last_scraped_at.to_i).to eq(previous_time.to_i)
      end
    end
  end
end
