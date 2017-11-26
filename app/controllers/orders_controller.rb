class OrdersController < ApplicationController
	def new
		@order = Order.new
	end


	def index
		if Figaro.env.execute_raw_querry == "true"
	      Rails.logger.info("Executing native querry")
	      @orders = Order.find_by_sql('select * from orders')
	      @orders = Order.all.paginate(page: params[:page], per_page: 5)
	    else
	      Rails.logger.info("Executing ruby statments")
	      @orderss = Order.all.paginate(page: params[:page], per_page: 5)
   		end
	end

	def show
		if Figaro.env.execute_raw_querry == "true"
	      Rails.logger.info("Executing native querry")
	      @order =  Order.find_by_sql("select * from orders where id = #{ params[:id] }").first
	    else
	      Rails.logger.info("Executing ruby statments")     
	      @order = Order.find(params[:id])
	    end
	end

	def create
		@order = Order.new(order_params)
		Rails.logger.info("customer id= #{@order.customer_id}")
		Rails.logger.info("payment type= #{params[:payment_type]}")
		Rails.logger.info("staff name= #{params[:staff_name]}")
		Rails.logger.info("phone number= #{params[:phone_no]}")
		Rails.logger.info("catalog_id= #{params[:catalog_id]}")
		Rails.logger.info("quantity= #{params[:quantity]}")

	         # TODO This is not returning sql result
		    Rails.logger.info("Executing native querry")
		    #@order = ActiveRecord::Base.connection.execute("insert into orders(customer_id) values('#{@order.customer_id})'")
		    #redirect_to :action => 'index'
		    payment = Payment.new
		    payment.payment_type = params[:payment_type]
		    payment = payment.create(skip_execute_raw_query: true)

		    shipment = Shipment.new(params[:staff_name], params[:phone_no])
		    shipment = shipment.create

		    @order.payment_id = payment.id
		    @order.shipment_id = shipment.id
		    @order.save

		    order_detail = OrderDetail.new(@order.id,params[:catalog_id_1], params[:quantity_1])
		    order_detail.create


		    order_detail = OrderDetail.new(@order.id,params[:catalog_id_2], params[:quantity_2])
		    order_detail.create

		    redirect_to :action => 'show'

	end

	def order_params
		params.require(:order).permit(:customer_id)
	end
	
end