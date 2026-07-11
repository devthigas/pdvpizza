class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    @customers = Customer.all.order(:name)
  end

  def show
    @orders = @customer.orders.order(created_at: :desc)
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: "Cliente cadastrado com sucesso!" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_path, notice: "Cliente atualizado com sucesso!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @customer.destroy
      respond_to do |format|
        format.html { redirect_to customers_path, notice: "Cliente excluído com sucesso!" }
      end
    else
      redirect_to customers_path, alert: @customer.errors.full_messages.to_sentence
    end
  end

  # GET /customers/search
  def search
    query = params[:q]
    @customers = if query.present?
      Customer.search(query).limit(10)
    else
      Customer.none
    end

    respond_to do |format|
      format.json { render json: @customers.map { |c| { id: c.id, name: c.name, phone: c.phone, address: c.address, neighborhood: c.neighborhood, full_address: c.full_address } } }
      format.html { render partial: "customers/search_results", locals: { customers: @customers } }
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.expect(customer: [:name, :cpf_cnpj, :phone, :address, :neighborhood, :reference_point, :notes])
  end
end
