require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @customer = customers(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get customers_url
    assert_response :success
    assert_select "h3", "Todos os Clientes"
  end

  test "should get new" do
    get new_customer_url
    assert_response :success
    assert_select "h2", "Cadastrar Novo Cliente"
  end

  test "should create customer" do
    assert_difference("Customer.count") do
      post customers_url, params: { customer: { name: "Cliente Teste", phone: "11988887777", cpf_cnpj: "11122233344", address: "Rua Teste", neighborhood: "Bairro Teste" } }
    end

    assert_redirected_to customers_url
    follow_redirect!
    assert_match "Cliente cadastrado com sucesso!", response.body
  end

  test "should show customer" do
    get customer_url(@customer)
    assert_response :success
    assert_select "h2", @customer.name
  end

  test "should get edit" do
    get edit_customer_url(@customer)
    assert_response :success
    assert_select "h2", "Editar Cadastro do Cliente"
  end

  test "should update customer" do
    patch customer_url(@customer), params: { customer: { name: "Nome Alterado" } }
    assert_redirected_to customers_url
    @customer.reload
    assert_equal "Nome Alterado", @customer.name
  end

  test "should destroy customer" do
    assert_difference("Customer.count", -1) do
      delete customer_url(@customer)
    end

    assert_redirected_to customers_url
  end

  test "should search customers" do
    get search_customers_url, params: { q: @customer.name }
    assert_response :success
    assert_match @customer.name, response.body
  end
end
