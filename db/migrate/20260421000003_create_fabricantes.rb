class CreateFabricantes < ActiveRecord::Migration[8.1]
  def change
    create_table :fabricantes do |t|
      t.string :nome_marca, limit: 100, null: false

      t.timestamps
    end
  end
end
