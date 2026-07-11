class DeliveryPersonsController < ApplicationController
  before_action :set_delivery_person, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_or_gerente, only: [:new, :create, :edit, :update, :destroy]

  def index
    @delivery_persons = DeliveryPerson.all.order(:name)
  end

  def show
  end

  def new
    @delivery_person = DeliveryPerson.new
  end

  def edit
  end

  def create
    @delivery_person = DeliveryPerson.new(delivery_person_params)

    respond_to do |format|
      if @delivery_person.save
        format.html { redirect_to delivery_persons_path, notice: "Entregador criado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @delivery_person.update(delivery_person_params)
        format.html { redirect_to delivery_persons_path, notice: "Entregador atualizado com sucesso!" }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @delivery_person.destroy
      respond_to do |format|
        format.html { redirect_to delivery_persons_path, notice: "Entregador excluído com sucesso!" }
        format.turbo_stream
      end
    else
      redirect_to delivery_persons_path, alert: @delivery_person.errors.full_messages.to_sentence
    end
  end

  private

  def set_delivery_person
    @delivery_person = DeliveryPerson.find(params[:id])
  end

  def delivery_person_params
    params.expect(delivery_person: [:name, :phone, :active])
  end

  def require_admin_or_gerente
    unless Current.session.user.admin? || Current.session.user.gerente?
      redirect_to root_path, alert: "Você não tem permissão para realizar esta ação."
    end
  end
end
