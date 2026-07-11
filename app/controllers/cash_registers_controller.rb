class CashRegistersController < ApplicationController
  before_action :set_cash_register, only: [:show, :close]

  def index
    @cash_registers = CashRegister.includes(:user).all.order(created_at: :desc)
    @current_cash_register = CashRegister.find_by(user: Current.session.user, status: :open)
  end

  def show
    @orders = @cash_register.orders.includes(:payments).order(created_at: :desc)
    # Agrupar totais por método de pagamento
    @payment_totals = Payment.joins(:order)
                             .where(orders: { cash_register_id: @cash_register.id, status: :completed })
                             .group(:payment_method)
                             .sum(:amount)
  end

  def new
    if CashRegister.where(user: Current.session.user, status: :open).exists?
      redirect_to cash_registers_path, alert: "Você já possui um caixa aberto!"
    else
      @cash_register = CashRegister.new
    end
  end

  def create
    @cash_register = CashRegister.new(cash_register_params)
    @cash_register.user = Current.session.user
    @cash_register.status = :open
    @cash_register.opened_at = Time.current

    if @cash_register.save
      redirect_to root_path, notice: "Caixa aberto com sucesso! Bom trabalho!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /cash_registers/:id/close
  def close
    closing_balance = params[:closing_balance].to_f
    if @cash_register.close!(closing_balance)
      redirect_to cash_register_path(@cash_register), notice: "Caixa fechado com sucesso!"
    else
      redirect_to cash_register_path(@cash_register), alert: "Erro ao fechar o caixa."
    end
  end

  private

  def set_cash_register
    @cash_register = CashRegister.find(params[:id])
  end

  def cash_register_params
    params.require(:cash_register).permit(:opening_balance, :observations)
  end
end
