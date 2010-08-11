class ElectricitySupplierController < AuthenticatedController

  def list
    @country = Country.find_by_id(params[:id])
    @suppliers = @country.electricity_suppliers
  end

  def show
    respond_to do |format|
      @supplier = ElectricitySupplier.find_by_id(params[:id])
      format.html
      format.xmlchart {
        # Send data
        render :layout => false
      }
    end
  end

end
