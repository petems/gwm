require 'middleware'

module Gwm
  module Middleware

    autoload :AskForCredentials, 'gwm/middleware/ask_for_credentials'
    autoload :Base, 'gwm/middleware/base'
    autoload :CheckConfiguration, 'gwm/middleware/check_configuration'
    autoload :CheckCredentials, 'gwm/middleware/check_credentials'
    autoload :Config, 'gwm/middleware/config'
    autoload :FollowUser, 'gwm/middleware/follow_user'
    autoload :InjectClient, 'gwm/middleware/inject_client'
    autoload :InjectConfiguration, 'gwm/middleware/inject_configuration'

    # Start the authorization flow.
    # This writes a ~/.gwm file, which can be edited manually.
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use InjectConfiguration
        use AskForCredentials
        use InjectConfiguration
        use CheckConfiguration
      end
    end

    # Follow repos based on criteria
    def self.sequence_follow_user
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FollowUser
      end
    end

    # This checks that the credentials in ~/.gwm are valid
    def self.sequence_verify
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    # Returns current used config
    def self.sequence_config
      ::Middleware::Builder.new do
        use Config
      end
    end

  end
end
