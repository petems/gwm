require 'gwm/cli'
require 'gwm/config'
require 'gwm/version'
require 'json'
require 'hashie'
require 'hashie/logger'

Hashie.logger = Logger.new(nil)

# TODO: do this properly
# See: https://github.com/intridea/hashie/issues/394
require 'hashie'
require 'hashie/logger'
Hashie.logger = Logger.new(nil)

module Gwm
end
