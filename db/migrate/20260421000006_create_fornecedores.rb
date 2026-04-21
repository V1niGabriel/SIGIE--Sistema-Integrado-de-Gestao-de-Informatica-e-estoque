class CreateFornecedores < ActiveRecord::Migration[8.1]
  def change
    create_table :fornecedores do |t|
      t.string :nome, limit: 80, null: false
      t.string :cnpj, limit: 14, null: false
      t.string :telefone, limit: 11, null: false
      t.string :email, limit: 100, null: false

      t.timestamps
    end

    add_index :fornecedores, :cnpj, unique: true
  end
end
