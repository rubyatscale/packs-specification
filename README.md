# packs

Welcome to `packs`! `packs` are a simple ruby specification for an extensible packaging system to help modularize Ruby applications.

A `pack` (also called `package`) is a folder of Ruby code with a `package.yml` at the root that is intended to represent a well-modularized domain, and the rest of the [rubyatscale](https://github.com/rubyatscale) ecosystem is intended to help make the boundaries between a pack and any other more clear.

Here are some example integrations with `packs`:
- [`stimpack`](https://github.com/rubyatscale/stimpack) can be used to integrate `packs` into your `rails` application
- [`rubocop-packs`](https://github.com/rubyatscale/rubocop-packs) contains cops to improve boundaries around `packs` 
- [`packwerk`](https://github.com/Shopify/packwerk) and [`packwerk-extensions`](https://github.com/rubyatscale/packwerk-extensions) help you describe and constrain your package graph in terms of dependencies between packs and pack public API
- [`code_ownership`](https://github.com/rubyatscale/code_ownership) gives your application the capability to determine the owner of a pack
- [`use_packs`](https://github.com/rubyatscale/use_packs) gives a CLI, `bin/packs`, that makes it easy to create new packs, move files between packs, and more.
- [`pack_stats`](https://github.com/rubyatscale/pack_stats) makes it easy to send metrics about pack adoption and modularization to your favorite metrics provider, such as DataDog (which has built-in support).

# How is a pack different from a gem?
A ruby [`gem`](https://guides.rubygems.org/what-is-a-gem/) is the Ruby community solution for packaging and distributing Ruby code. A gem is a great place to start new projects, and a great end state for code that's been extracted from an existing codebase. `packs` are intended to help gradually modularize an application that has some conceptual boundaries, but is not yet ready to be factored into gems.
