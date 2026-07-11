class PaymentsController < ApplicationController
  before_action :set_order

  # POST /orders/:order_id/payments
  def create
    @payment = @order.payments.new(payment_params)

    # Validar se o valor do pagamento não ultrapassa o total restante (com tolerância de troco apenas para dinheiro)
    remaining = @order.remaining_amount
    
    if @payment.amount.to_f <= 0
      redirect_to edit_order_path(@order), alert: "Valor do pagamento deve ser maior que zero."
      return
    end

    if !@payment.dinheiro? && @payment.amount.to_f > remaining
      redirect_to edit_order_path(@order), alert: "Para pagamentos em cartão ou pix, o valor não pode ser maior que o saldo restante de R$ #{'%.2f' % remaining}."
      return
    end

    respond_to do |format|
      if @payment.save
        @order.recalculate_totals! # atualiza o status de pagamento
        format.html { redirect_to edit_order_path(@order), notice: "Pagamento de R$ #{'%.2f' % @payment.amount} registrado." }
        format.turbo_stream
      else
        format.html { redirect_to edit_order_path(@order), alert: @payment.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_method, :amount)
  end
end
