module Gwm
  module Middleware
    # Check if the droplet in the environment is inactive, or "off"
    class Config < Base
      def call(env)
        config = Gwm::Configuration.instance

        config_data = config.data.to_yaml.delete('"')

        say "Current Config\n", :green

        say "Path: #{config.path}"
        say config_data

        @app.call(env)
      end
    end
  end
end
