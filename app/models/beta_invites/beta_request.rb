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
      user = USER_CLASS.new(email: email)
      # username validation isn't skipped...figure out how to skip this?
      if user.attributes.keys.include?("username")
        user.username = set_username_from(email)
      end
      if user = user.invite!
        user.name = self.name if user.attributes["name"] && !self.name.blank?         
        self.invite_sent = true
        self.invite_sent_at = Time.now
        self.user_id = user.id # id of new user being created
        self.save 
        user.save
        # Setting the new user as a creator.
      else
        puts "Could not create invite..."
      end
      return user
    end


  private

    def not_already_registered
      if user=USER_CLASS.find_by(email: email)
        errors.add :email, "is already registered. Use the links below to login."
      end
      
    end

    # generates a unique username given a base name
    def set_username_from(name)
      n = 0
      new_name = name
      while USER_CLASS.where("username = ?", new_name).present? do
        n+=1
        new_name = "#{name.split("@")[0]}#{n}" # accounts for emails and normal strings
      end
      new_name
    end

  end
end
