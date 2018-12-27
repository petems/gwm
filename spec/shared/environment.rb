require 'spec_helper'

shared_context 'spec' do
  # Default configuration and
  let(:config)             { Gwm::Configuration.instance }
  let(:access_token)       { 'foo' }
  let(:github_username)    { 'petems' }
  let(:github_password)    { 'hunter2' }
  let(:github_client)      { Octokit::Client.new(access_token: access_token) }
  let(:app)                { ->(env) {} }
  let(:env)                { {} }
  let(:cli)                { Gwm::CLI.new }

  before do
    # Set a temprary project path and create fake config.
    config.create_config_file(access_token)
    config.reload!
  end

  after do
    # Delete the temporary configuration file if it exists.
    File.delete(project_path + '/tmp/gwm') if File.exist?(project_path + '/tmp/gwm')
  end
end
