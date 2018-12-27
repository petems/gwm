require 'octokit'
require File.expand_path('../custom_logger', __FILE__)

module Gwm
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
      def call(env)
        # Sets the digital ocean client into the environment for use
        # later.
        @access_token = env['config'].access_token

        env['github'] = Octokit::Client.new(access_token: @access_token)

        env['github'].auto_paginate = true

        stack = Faraday::RackBuilder.new do |builder|
          builder.use CustomLogger if ENV['DEBUG']
          builder.adapter Faraday.default_adapter
        end

        env['github'].middleware = stack

        @app.call(env)
      end
    end
  end
end
