Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers:
    {
      omniauth_callbacks: 'omniauth_callbacks',
      registrations: 'registrations'
    }

  devise_scope :user do
    get 'email_required', to: 'registrations#email_required'
    post 'create_with_email', to: 'registrations#create_with_email'
    resources :users
  end

  root 'questions#index'
  get 'search', to: 'sphinx#search'

  concern :voteable do
    member do
      post 'vote_plus'
      post 'vote_minus'
      post 're_vote'
    end
  end

  concern :commentable do
    resources :comments, only: [:create, :show]
  end

  concern :tagged do
    get 'tagged/:tag', on: :collection, action: 'tagged_list', as: 'tagged'
  end

  resources :questions, concerns: [:voteable, :commentable, :tagged] do
    post 'subscribe', on: :member
    post 'unsubscribe', on: :member

    resources :answers, concerns: [:voteable, :commentable] do
      post 'best_answer', on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
