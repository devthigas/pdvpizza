class AdditionalsController < ApplicationController
  before_action :set_additional, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_gerente, only: [:new, :create, :edit, :update, :destroy]

  def index
    @additionals = Additional.all.order(:name)
  end

  def show
  end

  def new
    @additional = Additional.new
  end

  def edit
  end

  def create
    @additional = Additional.new(additional_params)

    respond_to do |format|
      if @additional.save
        format.html { redirect_to additionals_path, notice: "Adicional criado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @additional.update(additional_params)
        format.html { redirect_to additionals_path, notice: "Adicional atualizado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @additional.destroy
      respond_to do |format|
        format.html { redirect_to additionals_path, notice: "Adicional excluído com sucesso!" }
        format.turbo_stream
      end
    else
      redirect_to additionals_path, alert: @additional.errors.full_messages.to_sentence
    end
  end

  private

  def set_additional
    @additional = Additional.find(params[:id])
  end

  def additional_params
    params.expect(additional: [:name, :description, :price, :active])
  end

  def require_admin_or_gerente
    unless Current.session.user.admin? || Current.session.user.gerente?
      redirect_to root_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
