class Shipment < ActiveRecord::Base
	belongs_to :order_detail
	def initialize(staff_name,phone_no)
		@staff_name = staff_name
		@phone_no = phone_no
	end

	def create
		@status = "created"
		if Figaro.env.execute_raw_querry == "true"
			ActiveRecord::Base.connection.execute("insert into shipments(staff_name,phone_no,status) values('#{@staff_name}','#{@phone_no}','#{@status}')")
		else 
			self.save
		end
		return self	
	end
end
