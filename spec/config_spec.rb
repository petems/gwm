require 'spec_helper'

describe Gwm::Configuration do
  include_context 'spec'

  let(:tmp_path) { project_path + '/tmp/gwm' }

  after do
    # Clean up the temp file.
    File.delete(project_path + '/tmp/gwm') if File.exist?(project_path + '/tmp/gwm')
  end

  it 'is a singleton' do
    expect(described_class).to be_a Class
    expect do
      described_class.new
    end.to raise_error(NoMethodError, %r{private method `new' called})
  end

  it 'has a data attribute' do
    config = described_class.instance
    expect(config.data).to be
  end

  describe 'the file' do
    let(:access_token)       { 'foo' }

    let(:config) { described_class.instance }

    before do
      # Create a temporary file
      config.create_config_file(access_token)
    end

    it 'can be created' do
      expect(File.exist?(tmp_path)).to be_truthy
    end

    it 'can be loaded' do
      data = config.load_config_file
      expect(data).not_to be_nil
    end

    describe 'the file format'
    let(:data) { YAML.load_file(tmp_path) }

    it 'has authentication at the top level' do
      expect(data).to have_key('authentication')
    end

    it 'has an access token' do
      auth = data['authentication']
      expect(auth).to have_key('access_token')
    end

  end

end
