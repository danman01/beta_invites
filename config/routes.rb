BetaInvites::Engine.routes.draw do
  resources :beta_requests do
    member do
      post "send_invite"
    end
  end

  root to: "beta_requests#index"

end
