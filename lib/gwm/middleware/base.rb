module Gwm
  module Middleware
    # A base middleware class to initalize.
    class Base
      # Some colors for making things pretty.
      CLEAR      = "\e[0m".freeze
      RED        = "\e[31m".freeze
      GREEN      = "\e[32m".freeze
      YELLOW     = "\e[33m".freeze

      # We want access to all of the fun thor cli helper methods,
      # like say, yes?, ask, etc.
      include Thor::Shell

      def initialize(app)
        @app = app
        # This resets the color to "clear" on the user's terminal.
        say '', :clear, false
      end

      def call(env)
        @app.call(env)
      end

      def verify_credentials(github_client, say_success = false)
        begin
          response = github_client.user
          if response.error?
            say 'Authentication with Github failed: Error Response'
            say "Error response was: #{response.error}"
            exit 1
          end
        rescue Octokit::Error => e
          say 'Authentication with Github failed: Error Raised'
          say "Error raised was: #{e}"
          exit 1
        end

        say 'Authentication with Github was successful.', :green if say_success
      end

    end
  end
end
