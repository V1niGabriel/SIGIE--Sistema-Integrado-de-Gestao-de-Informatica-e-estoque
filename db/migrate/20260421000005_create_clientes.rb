class CreateClientes < ActiveRecord::Migration[8.1]
  def change
    create_table :clientes do |t|
      t.string :nome_razao_social, null: false
      t.string :cpf_cnpj, limit: 14, null: false
      t.string :telefone, limit: 11, null: false
      t.string :email, limit: 100, null: false

      t.timestamps
    end

    add_index :clientes, :cpf_cnpj, unique: true
  end
end
