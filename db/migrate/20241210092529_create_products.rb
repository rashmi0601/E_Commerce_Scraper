class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :contact_info
      t.string :size
      t.datetime :last_scraped_at
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
