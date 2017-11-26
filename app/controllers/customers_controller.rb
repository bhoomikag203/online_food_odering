class CustomersController < ApplicationController
	def index
		if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
			@customers = Customer.find_by_sql('select * from customers')
			@customers = Customer.all.paginate(page: params[:page], per_page: 5)
		else
			Rails.logger.info("Executing ruby statments")
			@customers = Customer.all.paginate(page: params[:page], per_page: 5)
		end
	end

	def show
		if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
			@customer =  Customer.find_by_sql("select * from customers where id = #{ params[:id] }").first
		else
			Rails.logger.info("Executing ruby statments")			
			@customer = Customer.find(params[:id])
		end
		render :not_found if @customer.nil?
	end

	def new
		@customer = Customer.new
	end

	def create
		@customer = Customer.new(customer_params)

         # TODO This is not returning sql result
         if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
		 	@customer = ActiveRecord::Base.connection.execute("insert into customers(name, address, email, phone_no) values('#{@customer.name}', '#{@customer.address}', '#{@customer. email}', '#{@customer.phone_no}')")
		 	redirect_to :action => 'index'
		 else
		 	Rails.logger.info("Executing ruby statments")
			if @customer.save
				redirect_to :action => 'index'
			else

				flash[:success] = "unable to save"
				render :action => 'new'
			end
		end
	end

	def customer_params
		params.require(:customer).permit(:name, :email, :address, :phone_no)
	end

	def edit
		if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
			@customer =  Customer.find_by_sql("select * from customers where id = #{ params[:id] }").first
		else
			Rails.logger.info("Executing ruby statments")			
			@customer = Customer.find(params[:id])
		end
	end

	def update
		# @existing_customer  = Customer.find(params[:id])
		@customer = Customer.new(customer_params)

		 # TODO This is not returning sql result
         if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
		 	@customer = ActiveRecord::Base.connection.execute("update customers set name = '#{@customer.name}', address = '#{@customer.address}', email = '#{@customer.email}', phone_no = '#{@customer.phone_no}' where id = #{ params[:id]}")
		 	redirect_to :action => 'show'
		else
			Rails.logger.info("Executing ruby statments")		 	
			if @customer.update_attributes(customer_params)
				redirect_to :action => 'show' , :id => @customer
				flash[:success] = " Updated "
		else
			render :action => 'edit'
		end
	end
end
	def destroy
		if Figaro.env.execute_raw_querry == "true"
			Rails.logger.info("Executing native querry")
			@customer =  ActiveRecord::Base.connection.execute("delete from customers where id = #{ params[:id] }")
			flash[:success] = "Customer deleted successfully"
			redirect_to :action => 'index'
		else
			Rails.logger.info("Executing ruby statments")
			Customer.find(params[:id]).destroy
			flash[:success] = "Customer deleted"
			redirect_to :action => 'index'
		end
	end

	def home
	end

end
