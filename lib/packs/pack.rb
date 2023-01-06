# typed: strict

module Packs
  class Pack < T::Struct
    extend T::Sig

    const :name, String
    const :path, Pathname
    const :relative_path, Pathname
    const :raw_hash, T::Hash[T.untyped, T.untyped]

    sig { params(package_yml_absolute_path: Pathname).returns(Pack) }
    def self.from(package_yml_absolute_path)
      package_loaded_yml = YAML.load_file(package_yml_absolute_path)
      path = package_yml_absolute_path.dirname
      relative_path = path.relative_path_from(Private.root)
      package_name = relative_path.cleanpath.to_s

      Pack.new(
        name: package_name,
        path: path,
        relative_path: relative_path,
        raw_hash: package_loaded_yml || {}
      )
    end

    sig { params(relative: T::Boolean).returns(Pathname) }
    def yml(relative: true)
      path_to_use = relative ? relative_path : path
      path_to_use.join(PACKAGE_FILE).cleanpath
    end

    sig { returns(String) }
    def last_name
      relative_path.basename.to_s
    end

    sig { returns(T::Boolean) }
    def is_gem?
      @is_gem ||= T.let(relative_path.glob('*.gemspec').any?, T.nilable(T::Boolean))
    end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def metadata
      raw_hash['metadata'] || {}
    end
  end
end
