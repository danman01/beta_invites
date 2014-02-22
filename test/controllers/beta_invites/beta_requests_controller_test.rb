require 'test_helper'

module BetaInvites
  class BetaRequestsControllerTest < ActionController::TestCase
    setup do
      @beta_request = beta_requests(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:beta_requests)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create beta_request" do
      assert_difference('BetaRequest.count') do
        post :create, beta_request: { comments: @beta_request.comments, email: @beta_request.email, invitation_token: @beta_request.invitation_token, invite_sent: @beta_request.invite_sent, invite_sent_at: @beta_request.invite_sent_at, invited_by: @beta_request.invited_by, kind: @beta_request.kind, user_id: @beta_request.user_id }
      end

      assert_redirected_to beta_request_path(assigns(:beta_request))
    end

    test "should show beta_request" do
      get :show, id: @beta_request
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @beta_request
      assert_response :success
    end

    test "should update beta_request" do
      patch :update, id: @beta_request, beta_request: { comments: @beta_request.comments, email: @beta_request.email, invitation_token: @beta_request.invitation_token, invite_sent: @beta_request.invite_sent, invite_sent_at: @beta_request.invite_sent_at, invited_by: @beta_request.invited_by, kind: @beta_request.kind, user_id: @beta_request.user_id }
      assert_redirected_to beta_request_path(assigns(:beta_request))
    end

    test "should destroy beta_request" do
      assert_difference('BetaRequest.count', -1) do
        delete :destroy, id: @beta_request
      end

      assert_redirected_to beta_requests_path
    end
  end
end
