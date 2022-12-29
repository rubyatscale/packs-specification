require_relative 'fixture_helper'

RSpec.configure do |config|
  config.include FixtureHelper

  config.before do
    # We bust_cache always because each test may write its own packs
    Packs.bust_cache!
  end

  config.around do |example|
    prefix = [File.basename($0), Process.pid].join('-') # rubocop:disable Style/SpecialGlobalVars
    tmpdir = Dir.mktmpdir(prefix)
    Dir.chdir(tmpdir) do
      example.run
    end
  ensure
    FileUtils.rm_rf(tmpdir)
  end
end
