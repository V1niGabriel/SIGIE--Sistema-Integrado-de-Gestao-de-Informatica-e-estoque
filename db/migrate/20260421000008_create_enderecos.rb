class CreateEnderecos < ActiveRecord::Migration[8.1]
  def change
    create_table :enderecos do |t|
      t.references :cliente, null: false, foreign_key: true
      t.string :rua, limit: 50, null: false
      t.integer :numero, null: false
      t.text :complemento
      t.string :bairro, limit: 50, null: false
      t.string :cidade, limit: 50, null: false
      t.string :estado, limit: 2, null: false
      t.string :cep, limit: 8, null: false

      t.timestamps
    end
  end
end
