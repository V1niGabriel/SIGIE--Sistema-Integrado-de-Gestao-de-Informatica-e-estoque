require "test_helper"

class DadosEmpresasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dados_empresa = dados_empresas(:one)
  end

  test "should get index" do
    get dados_empresas_url
    assert_response :success
  end

  test "should get new" do
    get new_dados_empresa_url
    assert_response :success
  end

  test "should create dados_empresa" do
    assert_difference("DadosEmpresa.count") do
      post dados_empresas_url, params: { dados_empresa: { bairro: @dados_empresa.bairro, cep: @dados_empresa.cep, cidade: @dados_empresa.cidade, cnpj: @dados_empresa.cnpj, complemento: @dados_empresa.complemento, estado: @dados_empresa.estado, ie: @dados_empresa.ie, im: @dados_empresa.im, numero: @dados_empresa.numero, razao_social: @dados_empresa.razao_social, regime_tributario: @dados_empresa.regime_tributario, rua: @dados_empresa.rua } }
    end

    assert_redirected_to dados_empresa_url(DadosEmpresa.last)
  end

  test "should show dados_empresa" do
    get dados_empresa_url(@dados_empresa)
    assert_response :success
  end

  test "should get edit" do
    get edit_dados_empresa_url(@dados_empresa)
    assert_response :success
  end

  test "should update dados_empresa" do
    patch dados_empresa_url(@dados_empresa), params: { dados_empresa: { bairro: @dados_empresa.bairro, cep: @dados_empresa.cep, cidade: @dados_empresa.cidade, cnpj: @dados_empresa.cnpj, complemento: @dados_empresa.complemento, estado: @dados_empresa.estado, ie: @dados_empresa.ie, im: @dados_empresa.im, numero: @dados_empresa.numero, razao_social: @dados_empresa.razao_social, regime_tributario: @dados_empresa.regime_tributario, rua: @dados_empresa.rua } }
    assert_redirected_to dados_empresa_url(@dados_empresa)
  end

  test "should destroy dados_empresa" do
    assert_difference("DadosEmpresa.count", -1) do
      delete dados_empresa_url(@dados_empresa)
    end

    assert_redirected_to dados_empresas_url
  end
end
