require "test_helper"

class MovimentacaoEstoquesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movimentacao_estoque = movimentacao_estoques(:one)
  end

  test "should get index" do
    get movimentacao_estoques_url
    assert_response :success
  end

  test "should get new" do
    get new_movimentacao_estoque_url
    assert_response :success
  end

  test "should create movimentacao_estoque" do
    assert_difference("MovimentacaoEstoque.count") do
      post movimentacao_estoques_url, params: { movimentacao_estoque: { compra_id: @movimentacao_estoque.compra_id, data: @movimentacao_estoque.data, funcionario_id: @movimentacao_estoque.funcionario_id, item_id: @movimentacao_estoque.item_id, motivo: @movimentacao_estoque.motivo, quantidade: @movimentacao_estoque.quantidade, tipo: @movimentacao_estoque.tipo, venda_id: @movimentacao_estoque.venda_id } }
    end

    assert_redirected_to movimentacao_estoque_url(MovimentacaoEstoque.last)
  end

  test "should show movimentacao_estoque" do
    get movimentacao_estoque_url(@movimentacao_estoque)
    assert_response :success
  end

  test "should get edit" do
    get edit_movimentacao_estoque_url(@movimentacao_estoque)
    assert_response :success
  end

  test "should update movimentacao_estoque" do
    patch movimentacao_estoque_url(@movimentacao_estoque), params: { movimentacao_estoque: { compra_id: @movimentacao_estoque.compra_id, data: @movimentacao_estoque.data, funcionario_id: @movimentacao_estoque.funcionario_id, item_id: @movimentacao_estoque.item_id, motivo: @movimentacao_estoque.motivo, quantidade: @movimentacao_estoque.quantidade, tipo: @movimentacao_estoque.tipo, venda_id: @movimentacao_estoque.venda_id } }
    assert_redirected_to movimentacao_estoque_url(@movimentacao_estoque)
  end

  test "should destroy movimentacao_estoque" do
    assert_difference("MovimentacaoEstoque.count", -1) do
      delete movimentacao_estoque_url(@movimentacao_estoque)
    end

    assert_redirected_to movimentacao_estoques_url
  end
end
