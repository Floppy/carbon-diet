ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "main", :action => "index"
  map.connect '/m', :controller => "main", :action => "mobile"

  # Connection for charts
  map.connect '/xml_chart/:action/:period/:user', :controller => "xml_chart" 

  # Connection for public profiles
  map.connect '/profile/:login', :controller => "profile", :action => "index"

  # Connection for admin interface
  map.connect '/admin', :controller => "admin/index", :action => "index"

  # Connection for group browser
  map.connect '/groups/browse/:string', :controller => "groups", :action => "browse"

  # Connection for data entry controllers
  map.connect '/data_entry/electricity/:account/:action/:id', :controller => "data_entry/electricity"
  map.connect '/data_entry/gas/:account/:action/:id', :controller => "data_entry/gas"
  map.connect '/data_entry/vehicle_fuel/:vehicle/:action/:id', :controller => "data_entry/vehicle_fuel"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
