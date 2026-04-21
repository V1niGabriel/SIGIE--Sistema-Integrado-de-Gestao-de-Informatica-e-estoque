class CreateCargos < ActiveRecord::Migration[8.1]
  def change
    create_table :cargos do |t|
      t.string :titulo, limit: 30, null: false
      t.string :descricao, limit: 255
      t.decimal :salario_base, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
