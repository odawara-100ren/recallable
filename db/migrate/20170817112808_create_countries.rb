class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.integer :age
      t.text :description
      t.string :name_of_top
      t.integer :country_number
      t.string :language
      t.string :name_of_capital

      t.timestamps
    end
  end
end
