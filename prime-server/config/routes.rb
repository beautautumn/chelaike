require "sidekiq/web"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "autobots" && password == "prime"
end if Rails.env.production?

Rails.application.routes.draw do
  scope :api do
    resources :enumerize_locales, only: :index do
      collection do
        get :app
      end
    end

    resources :util, only: [] do
      collection do
        get :image_base64, :shortener, :ip_information
        post :shortener
      end
    end

    # 车融易接口
    namespace :easy_loan do
      resources :messages
      resources :companies, only: [:show]
      resources :brands, only: [:index]
      resources :sessions, only: [:create] do
        post :code, on: :collection
      end
      resources :users, only: [:index, :update, :create] do
        get :me, on: :collection
        collection do
          post :rc_token
        end
      end
      resources :accredited_records, only: [:index, :create]
      resources :loan_bills, only: [:index, :show, :update, :create] do
        collection do
          get :brands, :brand_and_series
        end
      end
      resources :funder_companies, only: [:index]
      resources :authorities, only: [:index]
      resources :authority_roles, only: [:index, :update, :create]
      resources :regions, only: [] do
        collection do
          get :provinces
          get :cities
        end
      end
      resources :enumerize_locales, only: :index
    end

    namespace :open do
      resources :enumerize_locales, only: :index
      resources :detection
      namespace :v1 do
        resource :access_token, only: :create do
          collection do
            get :ping
          end
        end
        resource :company, only: [:show, :update] do
          collection do
            get :banners, :qrcode
          end
        end
        resources :cars, only: [:index, :show] do
          get :subscribe, :price_similar, :similar
        end
        resources :users, only: :show
        resources :brands, only: :index do
          collection do
            get :series, :styles, :style
          end
        end

        # 兼容 JSONP, 将所有动词改成 GET
        resources :service_appointments, only: :new
        resources :online_estimations, only: :new
        resources :sale_intentions, only: :new
      end

      namespace :v2 do
        resources :companies, only: [:index, :show] do
          get :alliance_owner_company
          get :alliance_members
          get :shops
        end

        resources :cities, only: [:index]

        resources :alliances, only: [:index, :show]
        resources :users, only: :show
        resources :brands, only: :index do
          collection do
            get :series, :styles, :style
          end
        end
        resources :sessions do
          get :verification_code, on: :collection
          post :verify, on: :collection
        end

        resources :cars, only: [:index, :update] do
          get :subscribe
          get :insurance_record, :detection_report
          collection do
            get :fetch_by_ids, :similar
            get :search, :ids_search, :short_search
          end

          member do
            get :maintenance_summary
            get :maintenance_detail
          end
        end

        resources :public_praises, only: :index do
          collection do
            get :sumup
          end
        end
      end

      namespace :v3 do
        resources :cars
        resources :shops do
          member do
            get :shops_by_company
            put :update_accredited
          end

          collection do
            get :all_cars
          end
        end
        resources :loan_bills do
          collection do
            post :notify
          end
        end

        resources :loan_accredited_records do
          collection do
            post :notify
          end
        end

        resources :replace_cars_bills do
          collection do
            post :notify
          end
        end
      end

      namespace :che300 do
        resources :cars, only: :index do
          get :detail, on: :collection
        end

        resources :brands, only: :index do
          collection do
            get :series, :styles
          end
        end

        resources :estimations, only: :index
        resources :identify_cars, only: :index
        resources :regions, only: :index

        # 返回给 车300 的车源信息
        resources :get_cars, only: :index
      end
    end

    namespace :v1 do
      resources :platform_brands, only: [:index] do
        collection do
          get :brands
        end
      end
      resources :red_dots, only: [:index]

      resources :token_bills

      resources :tokens do
        collection do
          get :all
          get :new_index
        end
      end

      resources :loan_bills do
        member do
          put :return_apply
        end

        collection do
          get :check_accredited
        end
      end

      resources :accredited_records
      resource :easy_loan_debit

      resources :funder_companies

      resources :maintenance_records, only: [:index, :show] do
        collection do
          get :detail
          post :upload_images
          post :fetch
          get :statistics
          get :statistics_report, action: :export
          get :time_hint, :shared_detail
        end
        member do
          post :refetch
          get :warehousing
          get :share_record
        end
      end

      resources :ant_queen_records, only: [:index, :show] do
        collection do
          get :detail
          post :fetch
        end
        member do
          post :refetch
          get :warehousing
        end
      end

      resources :che_jian_ding do
        collection do
          post :notify
        end
      end
      namespace :ant_queen do
        post :notify
        get :brands
      end

      resources :cha_doctor_records, only: [:index, :show] do
        collection do
          get :detail
          post :fetch
        end
        member do
          post :refetch
          get :warehousing
        end
      end

      namespace :cha_doctor do
        post :notify
      end

      resources :dashenglaile_records, only: [:index, :show] do
         collection do
           get :detail
           post :fetch
         end
         member do
           post :refetch
           get :warehousing
         end
       end

      namespace :dashenglaile do
        post :notify
        get :brands
      end

      resources :old_driver_records, only: [:index, :show] do
        collection do
          get :detail
          post :fetch
        end
        member do
          post :refetch
          get :warehousing
          get :share_record
        end
      end

      namespace :old_driver do
        post :notify
      end

      resources :pingpp do
        collection do
          post :notify
        end
      end
      resources :token_packages, only: :index do
        member do
          post :buy
        end
        collection do
          post :free_buy
        end
      end
      resource :oss_configuration, only: :create
      resource :recent_search_keyword, only: :show
      resource :daily_management, only: :show do
        get :unread, on: :collection
      end

      resources :authority_roles, only: [:create, :destroy, :index, :show, :update]
      resources :companies, only: [:index] do
        collection do
          get :shops
          get :cities_name
        end
      end

      namespace :alliance_dashboard do
        resources :reports, only: :new
        resource :oss_configuration, only: :create
        namespace :maintenance_records do
          get :detail
        end

        resources :companies do
          resources :warranties, only: [:index]
          resources :intention_levels, only: [:index, :create, :update, :destroy]
          member do
            get :channels, to: "channels#company_index"
          end
        end

        resources :channels, :authority_roles, :authorities

        resources :intentions do
          resources :intention_push_histories, only: [:index, :create]

          collection do
            put :batch_assign
            get :export
          end
        end

        resources :intention_levels

        resource :sessions, :alliances

        namespace :wechats do
          get :authorized_callback
          get :authorization
        end

        resources :users do
          collection do
            get :me
          end
          member do
            put :state
          end
        end

        resources :cars do
          resource :stock_out_inventory, only: [:show]
          resource :alliance_stock_out_inventory, only: [:show]
          member do
            put :update_images
            get :images_download
          end


          collection do
            get :out_of_stock
          end
        end
      end

      resources :app_versions, controller: :app_versions, only: [:show] do
        collection do
          get :production
        end
      end
      resource :publish_profile, only: [:show, :update, :destroy] do
        get :validation
      end

      resource :platform_profiles, only: [:show, :update, :destroy] do
        get :validation
        get :contacts, :sync_states
        get :validate_missings
        get :brands, :series, :styles
      end

      resource :publish_profile, only: [:show, :update, :destroy] do
        get :validation
        get :contacts
        get :publish
        get :validate_missings
      end
      resources :publish_sellers, only: [:index]

      resource :company, only: [:update, :show] do
        resource :app_version, controller: :company_app_version, only: :show

        put :automated_stock_number, :unified_management
        get :own_brand_alliances, :official_website_url, :financial_configuration, :check_accredited
        put :financial_configuration, to: "companies#update_financial_configuration"

        collection do
          get :customers
        end
      end
      resources :alliances, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :cars
          get "/cars/:id", action: :car
          get :companies
          get :companies_except_me
        end
        resources :cars, controller: :alliance_cars, only: [:index]
        resources :companies, controller: :alliance_companies, only: [:index, :show] do
          collection do
            get :no_allied
          end
        end
        resources :alliance_invitations, only: [:create] do
          collection do
            post :agree, :disagree
          end
        end
        member do
          patch :chat_group
        end
      end
      resources :alliance_company_relationships, only: [:destroy, :update]
      resources :shops, only: [:index, :update, :create, :destroy] do
        collection do
          get :query_city
        end
      end
      resources :channels, only: [:index, :create, :update, :destroy]
      resources :intention_levels, only: [:index, :create, :update, :destroy]
      resources :warranties, only: [:index, :create, :update, :destroy]
      resources :mortgage_companies, only: [:index, :create, :update, :destroy]
      resources :cooperation_companies, only: [:index, :create, :update, :destroy]
      resources :insurance_companies, only: [:index, :create, :update, :destroy]
      resources :price_tag_templates, only: :create
      resource  :intention_expiration, only: [:show, :update]
      resources :expiration_settings, only: [:index, :update]

      resources :messages, only: [:index, :show] do
        collection do
          get :server_send, :categoried_index, :unread
        end
      end
      resources :operation_records, only: [] do
        member do
          get :alliance_cars_created_statistic
        end
      end

      resources :cars, except: :new do
        member do
          get :qrcode, :meta_info, :alliance_similar, :similar, :alliances, :multi_images_share, :shared_url
          put :viewed
          put :alliances, to: "cars#update_alliances"
          put :onsale
        end

        collection do
          get :brands, :series, :out_of_stock, :acquirers, :sellers, :check_vin
          get :shared_car_list

          get "/transfer_records", to: "acquisition_transfers#index"
          get "/prepare_records", to: "prepare_records#index"
          get :info_by_vin
        end

        resource :detection_reports
        resource :acquisition_transfer
        resource :sale_transfer
        resource :price_tag, only: :show
        resource :prepare_record, only: [:show, :update]
        resource :car_reservation, only: [:create, :show, :update] do
          put :cancel
        end
        resource :car_relative_statistic, only: :show do
          get :sumup, on: :collection
        end
        resources :car_reservations, only: [:update]
        resources :car_state_histories, only: :create
        resource :stock_out_inventory, only: [:create, :update, :show]
        resource :alliance_stock_out_inventory, only: [:create, :update, :show]
        resource :refund_inventory, only: :create
        resources :car_price_histories, only: [:index, :create]
        resources :publishers, only: [:index] do
          collection do
            get :che168_state_sync
            post :sync
            post :publish # 新的同步接口
            delete :destroy
          end
        end

        collection do
          post :import # 车辆导入
          get :import_status # 查询车辆导入状态
          get :import_search #导入商家搜索
          resources :wechat_sharings, only: [:index]
        end
        get "images_download", to: "cars#images_download" # 图片打包下载
        put "images", to: "cars#images_update" #编辑图片
        resource :wechat_sharing, only: :show do
          member do
            get :allied_show
          end
        end
        resources :public_praises, only: :index do
          get :sumup, on: :collection
        end

        namespace :finance do
          resources :car_fees do
            collection do
              put :batch_update
              get :payment
              get :receipt
            end
          end
        end
      end # end of cars routes

      namespace :che_rong_yi do
        resources :cars
        resources :shops do
          collection do
            get :check_accredited
          end
        end

        resources :loan_bills do
          collection do
            get :post_check
          end

          member do
            post :repay
          end
        end

        resources :accredited_records do
          collection do
            get :funder_companies
          end
        end

        resources :replace_cars_bills
        resources :repayment_bills do
          collection do
            get :apply
          end
        end
      end

      resources :users, only: [:create, :update, :index, :show, :destroy] do
        put :state, :mobile_app_car_detail_menu, on: :member
        get :subordinate_users
        collection do
          get :selector, :me, :query_shop
        end

        post "feedback", to: "users#feedback", on: :collection # 用户反馈
        resources :authorities, only: [:index, :create] do
          collection do
            put :custom
            delete :destroy
            get :authority_roles
          end
        end
      end
      resources :task_statistics, only: :index
      resource :task_statistic, only: :show
      resource :statistics, only: :show do
        get :company, on: :collection
      end

      resource :car_statistic, only: :show do
        get :overview, on: :collection
      end
      resource :acquired_car_statistic, only: [] do
        collection do
          get :acquirers, :brands, :series, :ages,
              :acquisition_prices, :acquisition_types,
              :estimated_gross_profits, :stock_ages
        end
      end
      resource :out_of_stock_statistic, only: [] do
        collection do
          get :stock_out_modes, :closing_costs, :ages,
              :brands, :series, :appraisers, :sellers,
              :stock_ages
        end
      end
      resource :cash_flow, only: :show

      resources :customers, only: [:create, :show, :update, :index, :destroy] do
        member do
          get :intentions
        end
        collection do
          get :follow_up
          post :import
          get :memory_dates
        end
      end

      resource :user, only: [] do
        put :client_info
      end

      resource :password, only: [:edit, :update]

      resource :registrations, only: :create
      get "authorities", to: "authorities#index" # 公司下所有权限

      resources :sessions, only: :create
      resources :import_jobs, only: :show

      resources :brands, only: :index
      get "/series", to: "brands#series"
      get "/styles", to: "brands#styles"
      get "/style", to: "brands#style"
      get "/easy_config", to: "brands#easy_config"

      resources :reports, only: :new
      resources :regions do
        collection do
          get :provinces, :cities, :districts
        end
      end
      resources :che3bao_migrations, only: :create

      resources :intentions, only: [:index, :create, :update, :show] do
        resources :intention_push_histories, only: [:index, :create]

        collection do
          get :check
          put :batch_assign
          delete :batch_destroy
          post :import
          get :recycle, to: "intentions#to_be_recycled"
          put :recycle
        end

        member do
          get :cars, :alied_cars, :chat_detail
          put :share, :send_chat
        end
      end
      resources :daily_reports, only: :show

      resources :service_appointments, only: :index
      resources :car_appointments, only: :create
      resources :customer_service_intentions, only: [:index, :destroy]

      resources :import_tasks, only: :index
      resources :wechats, only: [] do
        collection do
          post :authorize_callback
          get :authorized_callback
          get :authorization
          get :pre_auth
        end

        member do
          post :events_callback
        end
      end

      get "ads", to: "advertisements#index"   # 广告

      namespace :weshop do
        resource :menus, only: [:show, :update]  do
          post :publish
        end
      end

      namespace :parallel do
        resources :styles, only: [:index, :show]
        resources :brands, only: [:index, :show]
        get 'phone', to: 'phones#show'
      end

      namespace :finance do
        resources :car_incomes, only: [:index, :show, :update] do
          collection do
            get :export
          end
          member do
            put :update_price, :update_fund_rate
          end
        end

        resources :shop_fees, only: [:index, :update] do
          collection do
            get :export
          end
        end
      end

      namespace :chat do
        resource :user, only: [] do
          post :rc_token
          get :groups
          get :all_users
          get :query_users
          get :system_messagers
        end
        resources :conversations, only: [:index] do
          collection do
            patch :sync
          end
        end

        resources :users, only: [:index, :show] do
          collection do
            get :alliances
          end
        end

        resources :messages, only: [] do
          collection do
            post :private_publish
          end
        end
        resources :groups, only: [:show] do
          resources :users, only: [:show]

          member do
            get :company
            get :alliance
            patch :name
            patch :nickname
            post :users, action: :join_users
            post :quit_users
            get :users, action: :users
            get :all_users
          end
        end

        resources :chat_sessions do
          collection do
            get :batch_infos
            get :info
          end
        end
      end

      resources :acquisition_car_infos do
        collection do
          get :brands, :series, :levels
        end

        member do
          post :confirm_acquisition
          post :forwarding
          put :assign
        end
        resources :acquisition_car_comments
      end
    end

    scope "param", module: "che3bao" do
      get "brandlist", to: "brands#brands"
      get "serieslist", to: "brands#series"
      get "modellist", to: "brands#styles"

      get "corpInfo", to: "companies#index"
    end

    scope "stock", module: "che3bao" do
      get "list", to: "cars#index"
      get "detail", to: "cars#show"
    end

    namespace :market do
      resources :users do
        collection do
          get :info
        end
      end

      resources :cars, only: :index
      resource :company, only: :update do
        post :sync_cars
      end
    end
  end

  resource :qrcode, only: :show
  get "/rqcode", to: "qrcodes#show"

  resources :cars, only: [] do
    resource :price_tag, only: :show
  end
  get "shortener/:id" => "shortener/shortened_urls#show"
  get "test", to: "util#test" # 用于检测是否可访问服务器


  mount Sidekiq::Web => "sidekiq"

  if Rails.env.development? || Rails.env.staging?
    mount Dashboard::Engine => "dashboard"
  elsif Rails.env.dashboard?
    constraints subdomain: "fighting" do
      mount Dashboard::Engine,  at: "/"
    end
  end

  if ENV.fetch("DOWNLOAD_PAGE", false) || Rails.env.download?
    # constraints subdomain: "download" do
    #   mount Download::Engine,  at: "/"
    # end
    mount Download::Engine, at: "/"
  end
end
