class Shipment < ApplicationRecord
  belongs_to :account
  has_many :packages, dependent: :destroy
  accepts_nested_attributes_for :packages
  validates :packages, presence: true
end
