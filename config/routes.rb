CarbonDiet::Application.routes.draw do
  
  root :to => 'main#index'
  
  match '/m' => 'main#mobile'

  # Connection for public profiles
  match '/profile/:login' => 'profile#index'

  # Connection for admin interface
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Resources
  resources :users do
    resource :accounts
    resources :flights
    resources :vehicles, :except => [:index, :show] do
      resources :vehicle_fuel_purchases
    end
    resources :electricity_accounts, :except => [:index, :show] do
      resources :electricity_readings
    end
    resources :gas_accounts, :except => [:index, :show] do
      resources :gas_readings
    end
    resources :notes
    resource :report do
      get :recent
      get :ratio
      get :recent_chart
      get :ratio_chart
    end
  end

  # Install the default route as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'

end