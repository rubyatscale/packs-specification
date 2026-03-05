# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this project is

`packs-specification` is a low-dependency Ruby gem that provides production-safe querying of [packs](https://github.com/rubyatscale/packs) configuration. It exposes `Packs.all` and `Packs.for_file` without pulling in development-only tooling.

## Commands

```bash
bundle install

# Run all tests (RSpec)
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/path/to/spec.rb

# Type checking (Sorbet)
bundle exec srb tc
```

## Architecture

- `lib/packs-specification.rb` — public API: `Packs.all`, `Packs.for_file`
- `lib/packs/` — `Pack` struct with fields from `package.yml`; configuration reader that locates packs via glob patterns
- `spec/` — RSpec tests
