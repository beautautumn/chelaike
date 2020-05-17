Rails.application.routes.draw do
  get 'home/search_page'
  get 'home/short_search'
  post 'home/condition_search'
  post 'home/ids_search'

  get 'me/enquiries'
  get 'me/favorites'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :me, to: 'me#index'
  get :contact, to: 'contact#index'
  get :home, to: 'home#index'
  get 'home/intro'
  get 'home/bargain_cars'

  get 'api/company_url/:id', to: 'api#company_url'
  get 'api/all_companies_url'
  post 'api/create_tenant'

  resources :sessions

  # 广告
  resources :advertisements, only: [:index, :show]

  namespace :admin do
    resource :session, only: [:new, :create, :destroy], path_names: { new: :login } do
      collection do
        get :code
      end
    end
    get '/', to: 'dashboard#index'
    resources :advertisements
    resources :recommended_cars
    resource :tenant, only: [:show, :update] do
      resource :site_configuration, only: [:show, :update]
      resource :car_configuration, only: [:show, :update]
      member do
        get :companies
        put :company
        get :alliances
        put :alliance
      end
    end

    resources :cars do
      collection do
        get :series
      end

      member do
        get :insurance_report
        post :sellable
      end

      resources :insurance_records do
        collection do
          get :import_report
        end
      end
      resources :transfer_histories
      resources :inspection_report, only: [:index, :create, :destroy]
      resource :maintenance_record do
        get :import
      end
    end
  end

  resources :cars, only: [:index, :show] do
    resources :pay, only: [:create]
    collection do
      get :snippet
      get :brand_and_series
      get :shared_index
      get :loan_data
    end
    member do
      put :like
      get :alliance_similar, :insurance_detail, :detail_config,
          :public_praises, :praises, :maintenance_detail,
          :inspection_report
    end
  end

  resources :enquiries

  resources :wechats, only: [:new, :destroy] do
    collection do
      post :authorize_callback
      get :authorized_callback

      get :pre_auth
      get :oauth

      # 微信扫码登录跳转
      get :scaned

      # js 轮训查询是否授权给 PC 登录
      get :login_loop_query
    end

    member do
      get :authorization
      get :oauth_callback
      post :events_callback
    end
  end

  resource :me, only: :index do
    member do
      get :enquiries
      get :favorites
    end
  end

  post 'pay/pay'
  get 'pay/index'
  post 'pay/notify'
  get 'pay/pay_result_query'

  get :test, to: "util#test" # 测试服务器是否工作正常
  get :invalid, to: "util#invalid_tenant" # 无效租户

  root "home#index"
end
