class ShipmentsController < ApplicationController
	def new
		@shipment = Shipment.new
	end

	def index
		if Figaro.env.execute_raw_querry == "true"
		    Rails.logger.info("Executing native querry")
		    @shipments = Shipment.find_by_sql('select * from shipments where status!="complete"')
		    @shipments = Shipment.all.paginate(page: params[:page], per_page: 5)
	    else
	      	Rails.logger.info("Executing ruby statments")
     		@shipments = Shipment.paginate(page: params[:page], per_page: 5)
    	end
	end

    def show
		if Figaro.env.execute_raw_querry == "true"
	      Rails.logger.info("Executing native querry")
	      @shipment =  Shipment.find_by_sql("select * from shipments where id = #{ params[:id] }").first
	    else
	      Rails.logger.info("Executing ruby statments")     
	      @shipment = Shipment.find(params[:id])
	    end
 	end

end
