require_relative 'fixture_helper'

RSpec.configure do |config|
  config.include FixtureHelper

  config.before do
    # We bust_cache always because each test may write its own packs
    Packs::Specification.bust_cache!
  end

  # Eventually, we could make this opt-in via metadata so someone can use this support without affecting all their tests.
  config.around do |example|
    if example.metadata[:skip_chdir_to_tmpdir]
      example.run
    else
      begin
        prefix = [File.basename($0), Process.pid].join('-') # rubocop:disable Style/SpecialGlobalVars
        tmpdir = Dir.mktmpdir(prefix)
        Dir.chdir(tmpdir) do
          example.run
        end
      ensure
        FileUtils.rm_rf(tmpdir)
      end
    end
  end
end
