class CreateDadosEmpresas < ActiveRecord::Migration[8.1]
  def change
    create_table :dados_empresas do |t|
      t.string :cnpj, limit: 14, null: false
      t.string :razao_social, null: false
      t.string :ie, null: false
      t.string :im, null: false
      t.integer :regime_tributario, null: false
      t.string :rua, limit: 50, null: false
      t.integer :numero, null: false
      t.text :complemento
      t.string :bairro, limit: 50, null: false
      t.string :cidade, limit: 50, null: false
      t.string :estado, limit: 2, null: false
      t.string :cep, limit: 8, null: false

      t.timestamps
    end

    add_index :dados_empresas, :cnpj, unique: true
  end
end
