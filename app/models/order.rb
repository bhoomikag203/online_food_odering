class Order < ActiveRecord::Base
	belongs_to :customer
	has_one :payment
	has_one :shipment
	has_many :order_details

	
end
