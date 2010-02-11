class DataChangeObserver < ActiveRecord::Observer

  observe :electricity_reading, :gas_reading, :vehicle_fuel_purchase, :flight, :vehicle, :electricity_account, :gas_account

  def after_save(record)
    record.user.update_stored_statistics!
  end

  def after_destroy(record)
    record.user.update_stored_statistics!
  end

end