Rails.application.routes.draw do
  resources :data_sources

  resources :source_files

  resources :crunch_algorithms

  resources :data_sets

  resources :reports

  root 'reports#index'

  get 'crunch_algorithms/:id/get_form', to: 'crunch_algorithms#get_form'
  get 'crunch_algorithms/:id/get_forms', to: 'crunch_algorithms#get_forms'
  get 'crunch_algorithms/:id/functions', to: 'crunch_algorithms#functions'
  put 'crunch_algorithms/:id/update_functions', to: 'crunch_algorithms#update_functions'

  get 'data_sources/:id/calculations_forms', to: 'data_sources#calculations_forms'
  get 'data_sources/:id/calculated_dimensions', to: 'data_sources#calculated_dimensions'
  put 'data_sources/:id/update_calculated_dimensions', to: 'data_sources#update_calculated_dimensions'
  get 'data_sources/:id/edit_calculated_dimensions', to: 'data_sources#edit_calculated_dimensions', as: 'edit_calculated_dimensions' 
  
  get 'crunch_algorithms/:id/delete_function', to: 'crunch_algorithms#delete_function'
  get 'reports/:id/crunch', to: 'reports#crunch', as: 'crunch' 
  get 'crunch_algorithms/:id/edit_functions', to: 'crunch_algorithms#edit_functions', as: 'edit_functions' 

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
