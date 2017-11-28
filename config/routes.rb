Rails.application.routes.draw do
	resources :customers
	resources :catalogs
	resources :orders
	resources :payments
	resources :shipments
	root 'customers#home'
end