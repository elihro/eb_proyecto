class CreatePropiedads < ActiveRecord::Migration[5.1]
  def change
    create_table :propiedads do |t|
      t.string :ad_type
      t.string :agency
      t.boolean :available
      t.integer :bathrooms
      t.string :city
      t.string :city_area
      t.string :content
      t.string :currency
      t.date :date
      t.integer :floor_area
      t.integer :floor_number
      t.string :id_extern
      t.float :latitute
      t.float :longitude
      t.integer :parking
      t.integer :plot_area
      t.integer :postcode
      t.float :price
      t.string :property_type
      t.string :region
      t.integer :rooms
      t.time :time
      t.string :title
      t.string :url
      t.string :unit_floor_area
      t.string :unit_plot_area

      t.timestamps
    end
  end
end
