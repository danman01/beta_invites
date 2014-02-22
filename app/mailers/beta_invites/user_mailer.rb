module BetaInvites
  class UserMailer < ActionMailer::Base
    default from: "from@example.com"

    def notify_invitee(invite_id, send_to_friend)
      @invite = BetaRequest.find(invite_id)
      @send_to_friend = send_to_friend
      if send_to_friend
        subject = "Someone invited you to check out MyApp!"
        @header_text = "Hey #{@invite.name}, someone thinks that you are the perfect fit for myapp!"
      else
        subject = "Your request to join has been received!"
      end
      # using same content right now for invites that useres send to others and request themselves
      mail(:to=>@invite.email, :subject => subject)
      
    end

    def notify_admins(invite_id)
      @invite = BetaRequest.find(invite_id)
      subject = "New beta invite! <#{@invite.email}>"
      mail(:to=>"admin@myapp.com", :subject => subject) 
    end
  end
end
