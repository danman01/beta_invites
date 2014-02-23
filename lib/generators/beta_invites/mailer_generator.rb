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
    My name is Julian and I’m one of the co-founders of Bundio, the direct-to-fan subscription platform.
    </p>
    <p>
    We built Bundio to enable artists that make cool things to distribute them directly to their biggest fans online. When you launch your subscription, you will be able to share your art with those that value it in a new, compelling format.
    </p>
    <p>
    Please allow us some time to handle the invite requests we’ve received thus far. Fear not, you’ll be launching your own subscription in no time!
    </p>
    <p>
    We’d love to hear about what you do! Please drop me a line by replying to this email or reaching out via the live chat tab on the website.
    </p>
    <p>
    Best,<br>
    Julian
    </p>
    <p>P.S.
      <%if @invite.invited_by.nil?%>
      <span> You received this email because you requested an invite at <a href="https://bundio.com" title="Bundio.com">Bundio.com</a></span>
    <%else%>
      <span> You were invited to use <a href="https://bundio.com" title="Bundio.com">Bundio</a> by <%=@invite.invited_by.email%></span>
      <p>They said: <%= @invite.comments %></p>
    <% end %>
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
