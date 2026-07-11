class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_gerente, only: [:new, :create, :edit, :update, :destroy]

  def index
    @flavors = Flavor.all.order(:name)
  end

  def show
  end

  def new
    @flavor = Flavor.new
  end

  def edit
  end

  def create
    @flavor = Flavor.new(flavor_params)

    respond_to do |format|
      if @flavor.save
        format.html { redirect_to flavors_path, notice: "Sabor criado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @flavor.update(flavor_params)
        format.html { redirect_to flavors_path, notice: "Sabor atualizado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @flavor.destroy
      respond_to do |format|
        format.html { redirect_to flavors_path, notice: "Sabor excluído com sucesso!" }
        format.turbo_stream
      end
    else
      redirect_to flavors_path, alert: @flavor.errors.full_messages.to_sentence
    end
  end

  private

  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.expect(flavor: [:name, :description, :ingredients, :active])
  end

  def require_admin_or_gerente
    unless Current.session.user.admin? || Current.session.user.gerente?
      redirect_to root_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
