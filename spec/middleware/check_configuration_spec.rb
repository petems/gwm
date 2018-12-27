require 'spec_helper'

describe Gwm::Middleware::CheckConfiguration do
  include_context 'spec'

  describe '.call' do
    it 'raises SystemExit with no configuration' do
      # Delete the temp configuration file.
      File.delete(project_path + '/tmp/gwm')

      expect { described_class.new(app).call(env) }.to raise_error(SystemExit).and output(%r{You must run `gwm authorize` in order to connect to Github}).to_stdout
    end
  end
end
