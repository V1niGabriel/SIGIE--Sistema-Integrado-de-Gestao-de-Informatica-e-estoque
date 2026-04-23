class Fabricante < ApplicationRecord
  # Um fabricante possui vários itens vinculados a ele
  has_many :itens, dependent: :restrict_with_error 
  
  # Novamente usando o restrict_with_error para garantir que você não 
  # exclua sem querer um fabricante que já tenha produtos cadastrados!
end
