class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_gerente, only: [:new, :create, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category).all.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
    @product.product_sizes.build if @product.is_pizza?
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_path, notice: "Produto cadastrado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to products_path, notice: "Produto atualizado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Produto excluído com sucesso!" }
        format.turbo_stream
      end
    else
      redirect_to products_path, alert: @product.errors.full_messages.to_sentence
    end
  end

  # GET /products/search
  def search
    query = params[:q]
    @products = if query.present?
      Product.active.where("name LIKE :q OR barcode = :literal OR sku = :literal", q: "%#{query}%", literal: query).limit(10)
    else
      Product.active.limit(10)
    end

    respond_to do |format|
      format.json { render json: @products.map { |p| { id: p.id, name: p.name, display_price: p.display_price, is_pizza: p.is_pizza, base_price: p.base_price, product_sizes: p.product_sizes.map { |ps| { id: ps.id, size_name: ps.size_name, price: ps.price, max_flavors: ps.max_flavors } } } } }
      format.html { render partial: "products/search_results", locals: { products: @products } }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    # Aceitamos tamanhos aninhados para pizzas
    params.require(:product).permit(
      :category_id, :name, :description, :barcode, :sku, :is_pizza, 
      :base_price, :cost_price, :current_stock, :unit, :min_stock, :active,
      product_sizes_attributes: [:id, :size_name, :price, :max_flavors, :_destroy]
    )
  end

  def require_admin_or_gerente
    unless Current.session.user.admin? || Current.session.user.gerente?
      redirect_to root_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
