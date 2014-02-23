require_dependency "beta_invites/application_controller"

module BetaInvites
  class BetaRequestsController < ApplicationController
    before_action :set_beta_request, only: [:show, :edit, :update, :destroy]

    # GET /beta_requests
    def index
      @beta_requests = BetaRequest.all
    end

    # GET /beta_requests/1
    def show
    end

    # GET /beta_requests/new
    def new
      @beta_request = BetaRequest.new
      @beta_request.email = params[:email]
      
    end

    # GET /beta_requests/1/edit
    def edit
    end

    # POST /beta_requests
    def create
      @beta_request = BetaRequest.new(beta_request_params)

      # you can enable users to invite new users. Track that here:
      if user_signed_in?
        @beta_request.invited_by = current_user
      end

      if @beta_request.save        
        # mailers should be in main app        
        redirect_to main_app.root_url, notice: 'Beta request was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /beta_requests/1
    def update
      if @beta_request.update(beta_request_params)
        redirect_to @beta_request, notice: 'Beta request was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /beta_requests/1
    def destroy
      @beta_request.destroy
      redirect_to beta_requests_url, notice: 'Beta request was successfully destroyed.'
    end

    # POST from beta_requests#idnex, to be used by admins to fire off invites
    def send_invite
      invitee=BetaInvites::BetaRequest.find(params[:id])
      user = invitee.send_invite!
      invitee.user.update_attributes({:invited_by_id=>current_user.id}) rescue nil
      user.is_a?(BetaInvites.user_class) ? flash[:notice] = "Invite sent!" : flash[:notice] = "Could not create user..."
      respond_to do |format|
        format.html {redirect_to root_url}
      end
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_beta_request
        @beta_request = BetaRequest.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def beta_request_params
        params.require(:beta_request).permit(:name, :city, :state, :zip, :country, :user_id, :invite_sent, :invitation_token, :invited_by, :invite_sent_at, :email, :kind, :comments)
      end
  end
end
