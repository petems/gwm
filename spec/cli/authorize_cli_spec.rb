require 'spec_helper'

describe Gwm::CLI do
  include_context 'spec'

  let(:tmp_path) { project_path + '/tmp/gwm' }

  describe 'authorize' do
    before do
    end

    it 'asks the right questions and checks credentials without 2FA' do

      auth_response = {
       "id": 1,
       "url": "https://api.github.com/authorizations/1",
       "scopes": [
         "user",
         "repo"
       ],
       "token": "mocked-github-response",
       "app": {
         "url": "http://my-github-app.com",
         "name": "my github app"
       },
       "note": "gwm-cli-token",
       "note_url": "http://optional/note/url",
       "updated_at": "2011-09-06T20:39:23Z",
       "created_at": "2011-09-06T17:26:27Z"
      }

      stub_request(:post, "https://api.github.com/authorizations").
        with(body: "{\"scopes\":[\"user\",\"repo\"],\"note\":\"gwm-cli-token\"}",
         headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic cGV0ZW1zOmh1bnRlcjI=', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}).
        to_return(status: 200, body: auth_response.to_json, headers: { 'Content-Type' => 'application/json' })

      expect($stdin).to receive(:gets).and_return(github_username)
      expect($stdin).to receive(:getpass).and_return(github_password)

      expect { cli.authorize }.to output(/Enter your Github username:/).to_stdout

      config = YAML.load_file(tmp_path)

      expect(config['authentication']['access_token']).to eq 'mocked-github-response'

      expect(a_request(:post, 'https://api.github.com/authorizations')).to have_been_made.once
    end

    it 'asks the right questions and checks credentials with 2FA' do

      auth_response = {
       "id": 1,
       "url": "https://api.github.com/authorizations/1",
       "scopes": [
         "user",
         "repo"
       ],
       "token": "mocked-github-response",
       "app": {
         "url": "http://my-github-app.com",
         "name": "my github app"
       },
       "note": "gwm-cli-token",
       "note_url": "http://optional/note/url",
       "updated_at": "2011-09-06T20:39:23Z",
       "created_at": "2011-09-06T17:26:27Z"
     }

     otp_response = {
       "message": "Must specify two-factor authentication OTP code."
     }

     stub_request(:post, "https://api.github.com/authorizations").
     with(
      body: "{\"scopes\":[\"user\",\"repo\"],\"note\":\"gwm-cli-token\"}",
      headers: {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Basic cGV0ZW1zOmh1bnRlcjI=', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.13.0'}
      ).
     to_return(
      {status: 401, body: otp_response.to_json, headers: { 'Content-Type' => "application/json", "X-GitHub-OTP" => "required; sms"}},
      {status: 200, body: auth_response.to_json, headers: { 'Content-Type' => 'application/json' }}
     )

     expect($stdin).to receive(:gets).and_return(github_username)
     expect($stdin).to receive(:getpass).and_return(github_password)
     expect($stdin).to receive(:gets).and_return('820123')

     expect { cli.authorize }.to output(/Enter your Two-Factor Auth Token:/).to_stdout

     config = YAML.load_file(tmp_path)

     expect(config['authentication']['access_token']).to eq 'mocked-github-response'

     expect(a_request(:post, 'https://api.github.com/authorizations')).to have_been_made.twice
   end

  end
end
