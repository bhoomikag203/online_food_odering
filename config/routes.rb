Rails.application.routes.draw do
	resources :customers
	resources :catalogs
	resources :orders
	root 'customers#home'
end