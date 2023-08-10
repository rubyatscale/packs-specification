# typed: strict

require 'yaml'
require 'pathname'
require 'sorbet-runtime'
require 'packs/pack'
require 'packs/specification'

# We let `packs-specification` define some API methods such as all, find, and for_file,
# because this allows a production environment to require `packs-specification` only and get some simple functionality, without
# needing to load all of `packs`.
module Packs
  PACKAGE_FILE = T.let('package.yml'.freeze, String)

  class << self
    extend T::Sig

    sig { returns(T::Array[Pack]) }
    def all
      Specification.all
    end

    sig { params(name: String).returns(T.nilable(Pack)) }
    def find(name)
      Specification.find(name)
    end

    sig { params(file_path: T.any(Pathname, String)).returns(T.nilable(Pack)) }
    def for_file(file_path)
      Specification.for_file(file_path)
    end
  end
end
