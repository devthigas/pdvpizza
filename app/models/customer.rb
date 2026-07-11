class Customer < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :phone, presence: true
  validates :cpf_cnpj, uniqueness: true, allow_blank: true

  scope :search, ->(query) {
    where("name LIKE :q OR phone LIKE :q OR cpf_cnpj LIKE :q", q: "%#{query}%")
  }

  def full_address
    [address, neighborhood, reference_point].compact_blank.join(" - ")
  end
end
