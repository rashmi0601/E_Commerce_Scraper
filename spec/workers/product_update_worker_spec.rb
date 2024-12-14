require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ProductUpdateWorker, type: :worker do
  Sidekiq::Testing.fake! 

  describe "#perform" do
    it "updates old products" do
      old_product = create(:product, updated_at: 1.year.ago)

      expect(Product).to receive(:update_old_products)

      ProductUpdateWorker.perform_async

      ProductUpdateWorker.drain
    end
  end
end
