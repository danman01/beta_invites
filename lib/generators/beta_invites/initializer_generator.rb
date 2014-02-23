module BetaInvites
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      def create_initializer_file
        create_file "config/initializers/beta_invites_initializer.rb", "# Add initialization content here"
      end
    end
  end
end
