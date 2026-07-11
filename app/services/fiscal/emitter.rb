module Fiscal
  class Emitter
    def self.emit(order)
      # TODO: implementar integração com NFC-e/NF-e/SAT
      Rails.logger.info "[Fiscal] Emissão fiscal pendente para pedido #{order.number}"
      { status: :not_configured }
    end
  end
end
