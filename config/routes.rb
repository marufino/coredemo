Rails.application.routes.draw do

  resources :competencies

  resources :assignments

  resources :projects

  resources :ratings

  resources :scores

  devise_for :users,  :controllers => { :registrations => "users/registrations" }

  match 'users/:id' => 'users#show', via: :get, :as => :user

  match 'users/' => 'users#index', via: :get

  resources :surveys

  resources :survey_blocks

  resources :questions

  root 'surveys#index'

  get 'survey_blocks/:id/sign' => 'survey_blocks#show_sign', as: :show_sign_survey
  post 'survey_blocks/:id/sign' => 'survey_blocks#sign', as: :sign_survey

  get 'users/data', :defaults => { :format => 'json' }

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
