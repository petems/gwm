require 'spec_helper'

describe Gwm::CLI do
  include_context 'spec'

  @user_json_response = {
    "id": 1234,
    "login": "stefanpenner",
    "email": "stefanpenner@gmail.com"
  }.to_json

  describe 'GMW_API_TOKEN=foobar' do
    it 'verifies with the ENV variable GMW_API_TOKEN' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token env-variable', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
        to_return(status: 200, body: @user_json_response, headers: { 'Content-Type' => 'application/json' })

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('GMW_API_TOKEN').and_return('env-variable')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expected_string = "Authentication with Github was successful.\n"
      expect { cli.verify }.to output(expected_string).to_stdout
      expect(a_request(:get, 'https://api.github.com/user').
        with {|req| req.headers == {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token env-variable', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}}).
        to have_been_made
    end

    it 'does not use ENV variable GMW_API_TOKEN if empty' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
        to_return(status: 200, body: @user_json_response, headers: { 'Content-Type' => 'application/json' })

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('GMW_API_TOKEN').and_return('')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expected_string = "Authentication with Github was successful.\n"
      expect { cli.verify }.to output(expected_string).to_stdout
      expect(a_request(:get, 'https://api.github.com/user').
        with {|req| req.headers == {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}}).
        to have_been_made
    end
  end
end
