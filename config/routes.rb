Rails.application.routes.draw do
   resources :propiedades

   root to: "propiedades#index"
end
