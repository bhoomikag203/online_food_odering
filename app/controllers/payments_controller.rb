class PaymentsController < ApplicationController
	def new
		@payment = Payment.new
	end

	def index
		if Figaro.env.execute_raw_querry == "true"
		      Rails.logger.info("Executing native querry")
		      @payments = Payment.find_by_sql('select * from payments where status!="Complete"')
		      @payments = Payment.all.paginate(page: params[:page], per_page: 5)
   		 else
		      Rails.logger.info("Executing ruby statments")
		      @payments = Payment.paginate(page: params[:page], per_page: 5)
		 end
	end

 	def edit
 		if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
			@payment =  Payment.find_by_sql("select * from payments where id = #{ params[:id] }").first
		else
			Rails.logger.info("Executing ruby statments")			
			@payment = Payment.find(params[:id])
		end
 	end

 	def update
		@payment = Payment.new(customer_params)
		 # TODO This is not returning sql result
			Rails.logger.info("Executing native querry")
		 	@payment = ActiveRecord::Base.connection.execute("update payments set status = 'Complete' where id = #{ params[:id]}")
		 	redirect_to :contoller => 'orders' ,:action => 'show'
	end
end



