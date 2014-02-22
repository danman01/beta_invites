module BetaInvites
  class BetaRequest < ActiveRecord::Base
    require 'valid_email'

    belongs_to :user, class_name: BetaInvites.user_class
    belongs_to :invited_by, :class_name => "User", :foreign_key => "invited_by"
    validates :email, :presence=>{:message=>"You must enter a valid email address!"}, :email=> true, 
      :uniqueness=>{:message=>"has already been used to request an invite"}
    validate :not_already_registered, :on => :create

    USER_CLASS = BetaInvites.user_class

    # after_create :identify_for_analytics
    def send_invite!
      email = self.email
      if user = USER_CLASS.invite!(:email => email, :name=>self.name)
        self.invite_sent = true
        self.invite_sent_at = Time.now
        self.user_id = user.id # id of new user being created
        # Setting the new user as a creator.
        if self.save      ..
          user.add_role!(USER_CLASS::ROLES[1])
          puts "Invite Sent!"
        else
          puts "Could not send...#{self.errors.first.to_s}"
        end
      else
        puts "Could not create invite..."
      end
      return user
    end


  private

    def not_already_registered
      if user=USER_CLASS.find_by_email(email)
        if user.has_role?("creator")
          errors.add :email, "is already registered as a creator.  Use the sign in links below or shoot us an email if you have any questions!"
          @role = "creator"
        else
          errors.add :email, "is already registered as a fan. Use the links below to login. Want to be a creator? Shoot us an email and we'll set it up!"
          @role = "fan"
        end
      end
      
    end

  end
end
