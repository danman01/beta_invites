Rails.application.routes.draw do

  authenticate :user do
    mount BetaInvites::Engine => "/beta_invites"
  end
end
