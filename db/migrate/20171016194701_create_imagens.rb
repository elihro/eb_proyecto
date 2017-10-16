class CreateImagens < ActiveRecord::Migration[5.1]
  def change
    create_table :imagens do |t|
      t.boolean :available
      t.integer :propiedad_id
      t.string :url

      t.timestamps
    end
  end
end
