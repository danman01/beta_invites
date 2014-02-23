$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "beta_invites/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "beta_invites"
  s.version     = BetaInvites::VERSION
  s.authors     = ["Danny Kirschner"]
  s.email       = ["rkirschner1377@gmail.com"]
  s.homepage    = "http://sharkswithlazers.net"
  s.summary     = "Add in ability to collect beta invite requests"
  s.description = "Beta invite requests can be collected, sent out and managed by admins. Goes with Devise and Devise Invitable."
  s.post_install_message = <<-TEXT
   now run generators and add this to the decorator:\n
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
    TEXT


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "devise", "~> 3.2.0"
  s.add_dependency "devise_invitable", "~> 1.3.0"
  s.add_dependency "valid_email", "~> 0.0.4"
  
  
  
  

  s.add_development_dependency "sqlite3"
end
