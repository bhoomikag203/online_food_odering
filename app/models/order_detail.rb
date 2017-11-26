class OrderDetail < ApplicationRecord
	belongs_to :order
	belongs_to :catalog
	# has_many :catalog

	def initialize(order_id,catalog_id,quantity)
		@order_id = order_id
		@catalog_id = catalog_id
		@quantity = quantity
	end

	def create
		if Figaro.env.execute_raw_querry == "true"
			ActiveRecord::Base.connection.execute("insert into order_details(order_id,catalog_id,quantity) values('#{@order_id}', '#{@catalog_id}', '#{@quantity}')")
		else 
			self.save
		end	
	end
end
