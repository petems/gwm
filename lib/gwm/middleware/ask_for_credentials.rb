require 'octokit'
require 'io/console'

module Gwm
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base

      SCOPES = %w(user repo)
      NOTE   = 'gwm-cli-token'

      def otp_header(token)
        { "X-GitHub-OTP" => token }
      end

      def replace_existing_token(github_client, error, otp_string)

        headers = {}
        headers = otp_header(otp_string) if otp_string

        if error.message =~ /already_exists/
          replace_token = ask("Token already exists with #{NOTE} name. Do you want to delete it?", :limited_to => ["yes", "no"])
          if replace_token.to_s == 'yes'
            id = github_client.authorizations(headers: headers).find { |auth| auth[:note] == NOTE }.id
            github_client.delete_authorization(id, headers: headers)
            say 'Token was deleted. Run `gwm authorize` again to create a new token'
            exit 0
          else
            say 'Token already exists, but chose not to delete. Exiting.'
            exit 0
          end
        else
          say 'Creating Token with Github failed'
          say "Error was: #{error}"
          exit 1
        end
      end

      def create_github_client(username, password)
        client = Octokit::Client.new(login: username, password: password)

        # ensure middleware raises errors on auth failure (so we can check if it's a 2FA requirement causing it)
        stack = Faraday::RackBuilder.new do |builder|
          # builder.response :logger # uncomment me to enable direct console logging of requests
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end

        Octokit.middleware = stack

        client
      end

      def call(env)
        say
        github_username = ask 'Enter your Github username:'
        github_password = STDIN.getpass("Enter your Github password:")

        client = create_github_client(github_username, github_password)

        begin
          token_response = client.create_authorization(scopes: SCOPES, note: NOTE)
        rescue Octokit::OneTimePasswordRequired
          two_factor_token = ask('Enter your Two-Factor Auth Token:')

          begin
            token_response = client.create_authorization(
              scopes: SCOPES,
              note: NOTE,
              headers: otp_header(two_factor_token)
            )
          rescue Octokit::UnprocessableEntity => e
            replace_existing_token(client, e, two_factor_token)
          end
        rescue Octokit::UnprocessableEntity => e
          replace_existing_token(client, e, false)
        end

        api_token = token_response.to_attrs[:token]

        # Write the config file.
        env['config'].create_config_file(api_token)
        env['config'].reload!

        say 'Config written to .gwm file!'

        @app.call(env)
      end
    end
  end
end


