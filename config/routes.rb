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
      resources :vehicle_fuel_purchases, :as => "fuel_purchases"
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
    resources :groups
    resources :friends do
      get :invite, :on => :collection
      post :send_invitation, :on => :collection
      post :accept, :on => :member
      post :reject, :on => :member
    end
  end
  resources :groups do
    resources :invitations
  end
  
  # Connection for group browser
  match '/groups/browse/:string' => 'groups#browse'

  # Install the default route as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'

end