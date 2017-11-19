Rails.application.routes.draw do
	resources :customers
	resources :catalogs
	root 'customers#home'
end