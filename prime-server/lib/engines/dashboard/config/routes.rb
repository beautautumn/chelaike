Dashboard::Engine.routes.draw do

  root "companies#index"

  resources :companies, only: [:index, :destroy] do
    put :honesty_tag, :active_tag, :own_brand_tag, :manage_active_tag
    member do
      get :edit_token
      post :update_token
      get :edit_advisor
      post :update_advisor
      get :add_label
      post :update_label
      post :reset_boss
    end
    collection do
      get :clear_tag
      get :clear_manage_tag
    end
  end

  resources :users, only: [:index, :destroy] do
    member do
      get :token
    end
  end
  resources :staffs, only: [:index, :create, :edit, :update, :destroy]
  resources :statistics, only: [:index, :show, :edit, :update], path_names: { edit: :manage }
  resources :operation_records, only: :index
  resource :session, only: [:new, :create, :destroy], path_names: { new: :login } do
    collection do
      get :code
    end
  end
  resources :alliances, only: :index do
    put :honesty_tag, :active_tag, :own_brand_tag
  end

  resources :daily_actives, only: :index do
    collection do
      get :company_dac
    end
  end
  resources :brands, only: [:index, :create, :edit, :update, :show]
  resources :series, only: [:create, :edit, :update, :show]
  resources :styles, only: [:create, :edit, :update]
  resources :ads
  resources :parallel_brands, shallow: true do
    resources :parallel_styles do
      member do
        put :delete_image
      end
    end
  end
  resources :apps do
    resources :app_versions
  end

  resources :intentions, only: :index
  resources :sales, only: :index
  resources :stocks, only: :index
  resources :orders, only: :index
  resources :maintenances, only: :index
  resources :vin_images, only: [:index, :show] do
    member do
      post :start_query
      post :response_error
    end
  end

  resources :old_drivers, only: [:index, :create, :show]

  scope '/api' do
    resources :cars, only: :show
  end

  resources :xiao_che_che do
    collection do
      post :publish
    end
  end

  scope "/easy_loan" do
    resource :setting, only: [:show, :update]
    resources :cities, only: [:index, :show, :update]
    resources :rating_statements, only: [:index, :edit, :update]
    resources :funder_companies
    resources :rating_companies, only: [:index, :edit, :update]
    resources :debits do
      collection do
        post :publish
        get :publish_page
      end
    end
  end
end
