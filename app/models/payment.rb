class Payment < ActiveRecord::Base
	belongs_to :order
	validates :order_id, presence: true
	def create(skip_execute_raw_query:)
		@status = "pending"
		if !skip_execute_raw_query && Figaro.env.execute_raw_querry == "true"
			ActiveRecord::Base.connection.execute("insert into payments(payment_type,status) values('#{@payment_type}', '#{@status}')")
		else 
			self.save
		end	
		return self
	end
end