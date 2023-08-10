# packs-specification
This is a low-dependency gem that allows your production environment to query simple information about [`packs`](https://github.com/rubyatscale/packs).


## Usage
```ruby

require 'packs-specification'

# Getting all packs
# Example use: adding pack paths to a list of fixture paths
# Returns a T::Array[Packs::Pack]
Packs.all

# Getting the pack for a specific file
# Example use: Associating a file with an owner via a pack owner
# Returns a T.nilable(Packs::Pack)
Packs.for_file('/path/to/file.rb')
Packs.for_file(Pathname.new('/path/to/file.rb')) # also works

# Getting a pack with a specific name
# Example use: Special casing certain behavior for a specific pack
# Example use: Development tools that operate on user inputted pack names
# Returns a T.nilable(Packs::Pack)
Packs.find('packs/my_pack')
```
