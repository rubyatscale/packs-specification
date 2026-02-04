# typed: strict

module Packs
  class Pack
    extend T::Sig

    sig { returns(String) }
    attr_reader :name

    sig { returns(Pathname) }
    attr_reader :path

    sig { returns(Pathname) }
    attr_reader :relative_path

    sig { params(name: String, path: Pathname, relative_path: Pathname).void }
    def initialize(name:, path:, relative_path:)
      @name = name
      @path = path
      @relative_path = relative_path
      @raw_hash = T.let(nil, T.nilable(T::Hash[T.untyped, T.untyped]))
      @is_gem = T.let(nil, T.nilable(T::Boolean))
    end

    sig { params(package_yml_absolute_path: Pathname).returns(Pack) }
    def self.from(package_yml_absolute_path)
      path = package_yml_absolute_path.dirname
      relative_path = path.relative_path_from(Specification.root)
      package_name = relative_path.cleanpath.to_s

      Pack.new(
        name: package_name,
        path: path,
        relative_path: relative_path
      )
    end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def raw_hash
      @raw_hash ||= YAML.load_file(yml(relative: false)) || {}
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
    def is_gem? # rubocop:disable Naming/PredicateName
      @is_gem ||= relative_path.glob('*.gemspec').any?
    end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def metadata
      raw_hash['metadata'] || {}
    end

    sig { returns(T::Array[Symbol]) }
    private def instance_variables_to_inspect = [:@name]

    if RUBY_VERSION < '4'
      sig { returns(String) }
      def inspect
        ivars = instance_variables_to_inspect.map do |ivar|
          "#{ivar}=#{instance_variable_get(ivar).inspect}"
        end.join(', ')
        "#<#{self.class.name}:0x#{object_id.to_s(16)} #{ivars}>"
      end
    end
  end
end
