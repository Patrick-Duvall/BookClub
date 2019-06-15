

Rails.application.routes.draw do

  get '/', to: "welcomes#home"

  # resources :books, only: [:index, :show, :new, :create, :destroy] do
    # resources :reviews, only: [:new, :create]
  # end
  get '/books/new', to: 'books#new', as: :new_book #errors if new is after show
  get '/books/:id', to: 'books#show', as: :book
  get '/books', to: 'books#index'
  post '/books', to: 'books#create'
  delete '/books/:id', to: 'books#destroy'


  get '/books/:book_id/reviews/new', to: 'reviews#new', as: :new_book_review
  post '/books/:book_id/reviews', to: 'reviews#create', as: :book_reviews

  # resources :reviews, only: [:destroy]
  delete '/reviews/:id', to: 'reviews#destroy', as: :review


  # resources :authors, only: [:show, :destroy]

  get '/authors/:id', to: 'authors#show', as: :author
  delete '/authors/:id', to: 'authors#destroy'


  # resources :users, only: :show
  get '/users/:id', to: 'users#show', as: :user
end
