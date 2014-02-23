module BetaInvites
  module Generators
    class DecoratorGenerator < Rails::Generators::Base
      #namespace "beta_invites"
      def create_folders
        decorator_path = "app/decorators/models/beta_invites/beta_request_decorator.rb"
        if File.exist?(decorator_path)
          puts "file exists!"
        else
          "`mkdir -p app/decorators/models/beta_invites/`"
          create_file "app/decorators/models/beta_invites/beta_request_decorator.rb" do
            "BetaInvites::BetaRequest.class_eval do"
          end

          inject_into_file(decorator_path, :after =>"BetaInvites::BetaRequest.class_eval do") do
  <<-ENDTEXT
    \n
    after_create :notify_invitee
    after_create :notify_admin

    private
    def notify_invitee
      UserMailer.notify_invitee(self.id,user_signed_in?).deliver
      puts "Notify invitee!"
    end

    def notify_admin
      UserMailer.notify_admins(self.id).deliver
      puts "Notify admin!"
    end
  end
  ENDTEXT
          end

        end
      end

   end
  end
end

