class Customer < ApplicationRecord
	validates :phone_no, format: { with: /\d{5}-\d{5}/, message: "bad format" }
end
