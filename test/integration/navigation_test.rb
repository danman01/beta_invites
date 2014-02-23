require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "can load index page" do
    get :index, use_route: :beta_invites
  end

  # test "the truth" do
  #   assert true
  # end
end

