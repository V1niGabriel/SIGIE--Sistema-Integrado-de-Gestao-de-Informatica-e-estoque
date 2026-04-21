class CreateCategorias < ActiveRecord::Migration[8.1]
  def change
    create_table :categorias do |t|
      t.string :nome_categoria, limit: 100, null: false

      t.timestamps
    end
  end
end
