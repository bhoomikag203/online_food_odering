class Orders < ActiveRecord::Base
	belongs_to :customer
	belongs_to :shipment
end