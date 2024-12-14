FactoryBot.define do
  factory :product do
    title { "Sample Product" }
    description { "This is a sample product." }
    price { 100.0 }
    size { "Large" }
    category
  end
end
