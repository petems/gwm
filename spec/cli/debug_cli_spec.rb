require 'spec_helper'

describe Gwm::CLI do
  include_context 'spec'

  @user_json_response = {
    "id": 1234,
    "login": "stefanpenner",
    "email": "stefanpenner@gmail.com"
  }.to_json

  describe 'DEBUG=1' do
    it 'shows raw logs when DEBUG=1' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
        to_return(status: 200, body: @user_json_response, headers: { 'Content-Type' => 'application/json' })

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('GMW_API_TOKEN').and_return('')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(1)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expectation = expect { cli.verify }

      expectation.to output(/Response Body/).to_stdout
      expectation.to output(/Authorization : token foo/).to_stdout
    end

    it 'shows redacted logs when DEBUG=2' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
        to_return(status: 200, body: @user_json_response, headers: { 'Content-Type' => 'application/json' })

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('GMW_API_TOKEN').and_return('')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(2)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expectation = expect { cli.verify }

      expectation.to output(/Response Body/).to_stdout
      expectation.to output(/Authorization : token \[TOKEN REDACTED\]/).to_stdout
    end
  end
end
