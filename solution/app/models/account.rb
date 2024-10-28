class Account < ApplicationRecord
    has_one :balance, dependent: :destroy
    has_many :shipments, dependent: :destroy
    accepts_nested_attributes_for :balance
    validates :balance, presence: true
end
