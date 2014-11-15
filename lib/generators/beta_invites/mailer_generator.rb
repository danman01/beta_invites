module BetaInvites
  module Generators
    class MailerGenerator < Rails::Generators::Base
      def create_user_mailer
        generate "mailer", "UserMailer"
      end

      def add_instructions_to_mailer
        inject_into_file "app/mailers/user_mailer.rb", :after => 'default from: "from@example.com"' do
<<-CONTENT
    \n
def notify_invitee(invite_id, send_to_friend)
  @invite = BetaInvites::BetaRequest.find(invite_id)
  @send_to_friend = send_to_friend
  if send_to_friend
    subject = "Someone invited you to check out MyApp!"
    @header_text = "Hey, someone thinks that you are the perfect fit for myapp!"
  else
    subject = "Your request to join has been received!"
  end
  # using same content right now for invites that useres send to others and request themselves
  mail(:to=>'@invite.email', :subject => subject)
  
end

def notify_admins(invite_id)
  @invite = BetaInvites::BetaRequest.find(invite_id)
  subject = "New beta invite! <'@invite.email'>"
  mail(:to=>"admin@myapp.com", :subject => subject) 
end
CONTENT
        end
      end

      def generate_views
        notify_admins_path = "app/views/user_mailer/notify_admins.html.erb"
        notify_invitee_path = "app/views/user_mailer/notify_invitee.html.erb"
        
      if File.exist?(notify_admins_path)
        puts "file exists!"
      else
        "`mkdir -p app/views/user_mailer/`"
        # create files
        text = "<!-- notify admin of a new beta invite -->"
        create_file "#{notify_admins_path}" do
          text
        end
        text2 = "<!-- notify invitee we received their request -->"
        create_file "#{notify_invitee_path}" do
          text
        end

        # inject text into files
        inject_into_file(notify_admins_path, :after =>text) do
<<-ENDTEXT
\n
<!DOCTYPE html>
<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
  </head>
  <body>
    Details:  <br />
    Name: <%=@invite.name%><br />
    Email: <%=@invite.email%><br />
    Comments: <%=@invite.comments%>
    <br />
    View all invites at /beta_invites
  </body>
</html>
ENDTEXT
        end

        inject_into_file(notify_invitee_path, :after =>text2) do
<<-ENDTEXT
\n
<!DOCTYPE html>
<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
  </head>
  <body>
    <div>
    </div>
    <p>
      Hi <%=@invite.name%>,
    </p>
    <p>
      Thanks for requesting an invite. We will get back to you soon.
   </p>
    <%= render :partial => 'email_unsubscribe' %>
  </body>
</html>


ENDTEXT
        end

      end



      end
    end
  end
end
