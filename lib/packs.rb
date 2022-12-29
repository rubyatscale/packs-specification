# typed: strict

require 'yaml'
require 'pathname'
require 'sorbet-runtime'
require 'packs/pack'
require 'packs/private'

module Packs
  PACKAGE_FILE = T.let('package.yml'.freeze, String)

  class << self
    extend T::Sig

    sig { returns(T::Array[Pack]) }
    def all
      packs_by_name.values
    end

    sig { params(name: String).returns(T.nilable(Pack)) }
    def find(name)
      packs_by_name[name]
    end

    sig { params(file_path: T.any(Pathname, String)).returns(T.nilable(Pack)) }
    def for_file(file_path)
      path_string = file_path.to_s
      @for_file = T.let(@for_file, T.nilable(T::Hash[String, T.nilable(Pack)]))
      @for_file ||= {}
      @for_file[path_string] ||= all.find { |package| path_string.start_with?("#{package.name}/") || path_string == package.name }
    end

    sig { void }
    def bust_cache!
      @packs_by_name = nil
      @config = nil
      @for_file = nil
    end

    sig { returns(Private::Configuration) }
    def config
      @config = T.let(@config, T.nilable(Private::Configuration))
      @config ||= Private::Configuration.fetch
    end

    sig { params(blk: T.proc.params(arg0: Private::Configuration).void).void }
    def configure(&blk)
      # If packs.yml is being used, then ignore direct configuration.
      # This is only a stop-gap to permit Stimpack users to more easily migrate
      # to packs.yml
      return if Private::Configuration::CONFIGURATION_PATHNAME.exist?

      yield(config)
    end

    private

    sig { returns(T::Hash[String, Pack]) }
    def packs_by_name
      @packs_by_name = T.let(@packs_by_name, T.nilable(T::Hash[String, Pack]))
      @packs_by_name ||= begin
        all_packs = package_glob_patterns.map do |path|
          Pack.from(path)
        end

        # We want to match more specific paths first so for_file works correctly.
        sorted_packages = all_packs.sort_by { |package| -package.name.length }
        sorted_packages.to_h { |p| [p.name, p] }
      end
    end

    sig { returns(T::Array[Pathname]) }
    def package_glob_patterns
      absolute_root = Private.root
      config.pack_paths.flat_map do |pack_path|
        Pathname.glob(absolute_root.join(pack_path).join(PACKAGE_FILE))
      end
    end
  end
end
