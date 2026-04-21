class CreateFuncionarios < ActiveRecord::Migration[8.1]
  def change
    create_table :funcionarios do |t|
      t.references :cargo, null: false, foreign_key: true
      t.string :nome, null: false
      t.string :cpf, limit: 11, null: false
      t.string :email, limit: 100, null: false
      t.string :telefone, limit: 11, null: false
      t.datetime :data_admissao, null: false
      t.string :senha_hash, null: false

      t.timestamps
    end

    add_index :funcionarios, :cpf, unique: true
    add_index :funcionarios, :email, unique: true
  end
end
