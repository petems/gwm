require 'spec_helper'

describe Gwm::Middleware::CheckCredentials do
  include_context 'spec'

  describe '.call' do
    it 'raises SystemExit with no configuration' do
      user_response = {
        "id": 1234,
        "login": "stefanpenner",
        "email": "stefanpenner@gmail.com"
      }

      stub_request(:get, "https://api.github.com/user").
         with(headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
         to_return(status: 200, body: user_response.to_json, headers: { 'Content-Type' => 'application/json' })

      # Inject the client
      env['github'] = github_client

      expect { described_class.new(app).call(env) }.to output("Authentication with Github was successful.\n").to_stdout
      expect(a_request(:get, 'https://api.github.com/user')).to have_been_made.once
    end
  end
end
