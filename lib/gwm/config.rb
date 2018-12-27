require 'singleton'

module Gwm
  # This is the configuration object. It reads in configuration
  # from a .gwm file located in the user's home directory

  class Configuration
    include Singleton
    attr_reader :data
    attr_reader :path

    FILE_NAME = '.gwm'.freeze

    # Load config file from current directory, if not exit load from user's home directory
    def initialize
      @path = File.join(File.expand_path('.'), FILE_NAME)
      unless File.exist?(@path)
        @path = (ENV['GWM_CONFIG_PATH'] || File.join(File.expand_path('~'), FILE_NAME))
      end
      @data = load_config_file
    end

    # If we can't load the config file, self.data is nil, which we can
    # check for in CheckConfiguration
    def load_config_file
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      return
    end

    def access_token
      env_access_token || @data['authentication']['access_token']
    end

    def env_access_token
      ENV['GMW_API_TOKEN'] unless ENV['GMW_API_TOKEN'].to_s.empty?
    end

    # Re-runs initialize
    def reset!
      send(:initialize)
    end

    # Re-loads the config
    def reload!
      @data = load_config_file
    end

    # Writes a config file
    def create_config_file(access_token)
      require 'yaml'
      File.open(@path, File::RDWR | File::TRUNC | File::CREAT, 0o600) do |file|
        data = {
          'authentication' => {
            'access_token' => access_token
          },
        }
        file.write data.to_yaml
      end
    end
  end
end
