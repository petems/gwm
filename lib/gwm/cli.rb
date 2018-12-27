require 'thor'

module Gwm
  autoload :Middleware, 'gwm/middleware'

  class CLI < Thor
    include Thor::Actions
    ENV['THOR_COLUMNS'] = '120'

    !check_unknown_options

    class_option :quiet, type: :boolean, aliases: '-q'

    map '--version'      => :version,
        '-v'             => :version

    desc 'help [COMMAND]', 'Describe commands or a specific command'
    def help(meth = nil)
      super
      say 'To learn more or to contribute, please see github.com/petems/gwm' unless meth
    end

    desc 'authorize', 'Authorize your Github account for gwm'
    long_desc "This takes you through a workflow for adding configuration
    details to gwm. First, you are asked for your API and Client keys,
    which are stored in ~/.gwm.

    You can retrieve your credentials from https://cloud.digitalocean.com/api_access
    "
    def authorize
      Middleware.sequence_authorize.call('gwm_action' => __method__,
                                         'user_quiet' => options[:quiet])
    end

    desc 'config', 'Show your current config information'
    long_desc "This shows the current information in the .gwm config
    being used by the app
    "
    method_option 'hide',
                  type: :boolean,
                  default: true,
                  aliases: '-h',
                  desc: 'Hide your API keys'
    def config
      Middleware.sequence_config.call('gwm_action' => __method__,
                                      'user_hide_keys' => options[:hide])
    end

    desc 'verify', 'Check your DigitalOcean credentials'
    long_desc "This tests that your credentials created by the \`authorize\`
    command that are stored in ~/.gwm are correct and allow you to connect
    to the API without errors.
    "
    def verify
      Middleware.sequence_verify.call('gwm_action' => __method__,
                                      'user_quiet' => options[:quiet])
    end

    desc 'user_follow', 'Follow a list of repos from a given user'
    long_desc "This allows you to mass follow Github repos based on a given
    username.
    "
    method_option 'ignore_forks',
                  type: :boolean,
                  aliases: '-i',
                  desc: 'Do not follow forked repos'
    def user_follow(user)
      Middleware.sequence_follow_user.call(
                                      'gwm_action' => __method__,
                                      'user_follow' => user,
                                      'forked_repo_ignore' => options[:ignore_forks],
                                      )
    end

    desc 'version', 'Show version'
    def version
      say "Gwm #{Gwm::VERSION}"
    end

  end
end
