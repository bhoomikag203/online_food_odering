class PaymentsController < ApplicationController
	def new
		@payment = Payment.new
	end

	def index
		if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @payments = Payment.find_by_sql('select * from payments where status!="complete"')
      @payments = Payment.all.paginate(page: params[:page], per_page: 5)
    else
      Rails.logger.info("Executing ruby statments")
      @payments = Payment.paginate(page: params[:page], per_page: 5)
    end
	end

    def show
		if Figaro.env.execute_raw_querry == "true"
	      Rails.logger.info("Executing native querry")
	      @payment =  Payment.find_by_sql("select * from payments where id = #{ params[:id] }").first
	    else
	      Rails.logger.info("Executing ruby statments")     
	      @payment = Payment.find(params[:id])
	    end
 	end

end
