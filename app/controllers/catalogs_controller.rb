class CatalogsController < ApplicationController
  def index
    if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @catalogs = Catalog.find_by_sql('select * from catalogs')
      @catalogs = Catalog.all.paginate(page: params[:page], per_page: 5)
    else
      Rails.logger.info("Executing ruby statments")
      @catalogs = Catalog.paginate(page: params[:page], per_page: 5)
    end
  end

  def new
    @catalog = Catalog.new
  end

  def show
    if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @catalog =  Catalog.find_by_sql("select * from catalogs where id = #{ params[:id] }").first
    else
      Rails.logger.info("Executing ruby statments")     
      @catalog = Catalog.find(params[:id])
    end
  end

  def create
   @catalog = Catalog.new(catalog_params)

         # TODO This is not returning sql result
      if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @catalog = ActiveRecord::Base.connection.execute("insert into catalogs(name, price) values('#{@catalog.name}','#{@catalog.price}')")
      redirect_to :action => 'index'
     else
      Rails.logger.info("Executing ruby statments")
      if @catalog.save
        redirect_to :action => 'index'
      else

        flash[:success] = "unable to save"
        render :action => 'new'
      end
    end
  end

  def edit
    if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @catalog =  Catalog.find_by_sql("select * from catalogs where id = #{ params[:id] }").first
    else
      Rails.logger.info("Executing ruby statments")     
      @catalog = Catalog.find(params[:id])
    end
  end

  def update
    @catalog  = Catalog.new(catalog_params)
     # TODO This is not returning sql result
          if Figaro.env.execute_raw_querry == "true"
              Rails.logger.info("Executing native querry")
              @catalog = ActiveRecord::Base.connection.execute("update catalogs set name = '#{@catalog.name}', price = '#{@catalog.price}' where id = #{ params[:id]}")
              redirect_to :action => 'show'
          else
           Rails.logger.info("Executing ruby statments")     
            if @catalog.update_attributes(catalog_params)
              redirect_to :action => 'show' , :id => @catalog
              flash[:success] = " Updated "
            else
              render :action => 'edit'
             end
          end
  end

  def destroy
    if Figaro.env.execute_raw_querry == "true"
      Rails.logger.info("Executing native querry")
      @catalog =  ActiveRecord::Base.connection.execute("delete from catalogs where id = #{ params[:id] }")
      flash[:success] = "Item deleted successfully"
      redirect_to :action => 'index'
    else
      Rails.logger.info("Executing ruby statments")
      Catalog.find(params[:id]).destroy
      flash[:success] = "Item deleted"
      redirect_to :action => 'index'
    end
  end


  def catalog_params
    params.require(:catalog).permit(:name, :price)
  end

end
