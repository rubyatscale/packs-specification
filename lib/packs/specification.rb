# typed: strict

require 'packs/specification/configuration'

module Packs
  module Specification
    extend T::Sig

    class << self
      extend T::Sig

      sig { returns(Pathname) }
      def root
        Pathname.pwd
      end

      sig { returns(Configuration) }
      def config
        @config = T.let(@config, T.nilable(Configuration))
        @config ||= Configuration.fetch
      end

      sig { void }
      def bust_cache!
        @packs_by_name = nil
        @for_file = nil
        @config = nil
      end

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
        absolute_root = Specification.root
        Specification.config.pack_paths.flat_map do |pack_path|
          Pathname.glob(absolute_root.join(pack_path).join(PACKAGE_FILE))
        end
      end
    end
  end
end
