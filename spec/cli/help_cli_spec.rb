require 'spec_helper'

describe Gwm::CLI do
  include_context 'spec'

  describe 'help' do
    it 'shows a help message' do
      expected_string = %r{To learn more or to contribute, please see}
      expect { cli.help }.to output(expected_string).to_stdout
    end

    it 'shows a help message for specific commands' do
      expected_string = %r{This takes you through a workflow for adding configuration details to gwm.}
      expect { cli.help 'authorize' }.to output(expected_string).to_stdout
    end
  end
end
