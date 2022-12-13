# typed: strict

module Packs
  class Configuration
    extend T::Sig

    sig { params(roots: T::Array[String]).void }
    attr_writer :roots

    sig { void }
    def initialize
      @roots = T.let(ROOTS, T::Array[String])
    end

    sig { returns(T::Array[Pathname]) }
    def roots
      @roots.map do |root|
        Pathname.new(root)
      end
    end
  end

  class << self
    extend T::Sig

    sig { returns(Configuration) }
    def config
      @config = T.let(@config, T.nilable(Configuration))
      @config ||= Configuration.new
    end

    sig { params(blk: T.proc.params(arg0: Configuration).void).void }
    def configure(&blk)
      yield(config)
    end
  end
end
