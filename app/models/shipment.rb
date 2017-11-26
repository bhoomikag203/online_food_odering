class Shipment < ActiveRecord::Base
	belongs_to :order
	
	def create(skip_execute_raw_query:)
		@status = "Created"
		if !skip_execute_raw_query && Figaro.env.execute_raw_querry == "true"
			ActiveRecord::Base.connection.execute("insert into shipments(staff_name,phone_no,status) values('#{@staff_name}','#{@phone_no}','#{@status}')")
		else 
			self.save
		end
		return self	
	end
end
