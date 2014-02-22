BetaInvites::Engine.routes.draw do
  resources :beta_requests

  root to: "beta_requests#index"

end
