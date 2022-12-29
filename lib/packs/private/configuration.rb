# typed: strict

module Packs
  module Private
    class Configuration < T::Struct
      extend T::Sig
      CONFIGURATION_PATHNAME = T.let(Pathname.new('packs.yml'), Pathname)

      DEFAULT_PACK_PATHS = T.let([
        'packs/*',
        'packs/*/*',
      ], T::Array[String])

      prop :pack_paths, T::Array[String]
      const :user_specified_pack_paths, T::Boolean

      sig { returns(Configuration) }
      def self.fetch
        config_hash = CONFIGURATION_PATHNAME.exist? ? YAML.load_file(CONFIGURATION_PATHNAME) : {}

        new(
          pack_paths: pack_paths(config_hash),
          user_specified_pack_paths: !config_hash['pack_paths'].nil?
        )
      end

      sig { params(config_hash: T::Hash[T.untyped, T.untyped]).returns(T::Array[String]) }
      def self.pack_paths(config_hash)
        specified_pack_paths = config_hash['pack_paths']
        if specified_pack_paths.nil?
          DEFAULT_PACK_PATHS.dup
        else
          Array(specified_pack_paths)
        end
      end
    end
  end
end
