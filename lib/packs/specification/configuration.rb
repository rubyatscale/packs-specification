# typed: strict

module Packs
  module Specification
    class Configuration < T::Struct
      extend T::Sig
      CONFIGURATION_PATHNAME = T.let(Pathname.new('packs.yml'), Pathname)

      DEFAULT_PACK_PATHS = T.let([
                                   'packs/*',
                                   'packs/*/*'
                                 ], T::Array[String])
      DEFAULT_README_TEMPLATE_PATHNAME = T.let(Pathname.new('README_TEMPLATE.md'), Pathname)

      prop :pack_paths, T::Array[String]
      prop :readme_template_pathname, Pathname

      sig { returns(Configuration) }
      def self.fetch
        config_hash = CONFIGURATION_PATHNAME.exist? ? YAML.load_file(CONFIGURATION_PATHNAME) : {}

        new(
          pack_paths: pack_paths(config_hash),
          readme_template_pathname: readme_template_pathname(config_hash)
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

      sig { params(config_hash: T::Hash[T.untyped, T.untyped]).returns(Pathname) }
      def self.readme_template_pathname(config_hash)
        specified_readme_template_path = config_hash['readme_template_path']
        if specified_readme_template_path.nil?
          DEFAULT_README_TEMPLATE_PATHNAME
        else
          Pathname.new(specified_readme_template_path)
        end
      end
    end
  end
end
