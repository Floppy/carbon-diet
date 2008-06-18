class ElectricitySupplierController < AuthenticatedController

  def list
    @country = Country.find_by_id(params[:id])
    @suppliers = @country.electricity_suppliers
  end

  def show
    @supplier = ElectricitySupplier.find_by_id(params[:id])
  end

end
