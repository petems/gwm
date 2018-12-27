require 'spec_helper'

describe Gwm::CLI do
  include_context 'spec'

  describe 'config' do
    it 'shows the full config' do
      expected_string = <<-eos
Current Config
Path: #{Dir.pwd}/tmp/gwm
---
authentication:
  access_token: foo
      eos

      expect { cli.config }.to output(expected_string).to_stdout
    end
  end
end
