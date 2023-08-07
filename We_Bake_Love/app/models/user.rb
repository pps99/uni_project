class User < ApplicationRecord
  has_secure_password
  has_many :cakes, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  validates :name, presence: true
  validates :email,presence: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ }
  with_options on: [:uploaded] do
    validates :password, presence: true
  end
  validates :phone, length: { maximum: 20 }, format: { with: /\A(09|\959)\d{7,9}\z/ }
  validates :address, presence: true
end
