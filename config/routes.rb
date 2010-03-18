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

  # Connection for public profiles
  map.connect '/profile/:login', :controller => "profile", :action => "index"

  # Connection for admin interface
  map.connect '/admin', :controller => "admin/dashboard", :action => "index"

  # Connection for group browser
  map.connect '/groups/browse/:string', :controller => "groups", :action => "browse"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # New-style resourceful routes
  map.resources :users do |user|
    user.resource :accounts
    user.resources :flights
    user.resources :vehicles do |vehicle|
      vehicle.resources :vehicle_fuel_purchases, :as => "fuel_purchases"
    end
    user.resources :electricity_accounts do |elec|
      elec.resources :electricity_readings, :as => "readings"
    end
    user.resources :gas_accounts do |gas|
      gas.resources :gas_readings, :as => "readings"
    end
    user.resources :notes
    user.resource :report, :member => {:recent => :get, :ratio => :get}
    user.resources :groups, :controller => "user_groups"
    user.resources :friends, :collection => {
      :invite => :get
    }
  end
  map.resources :groups, :member => {:invite => :get} do |group|
    group.resources :invitations
  end

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
