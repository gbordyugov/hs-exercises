# Haskell Exercises

Single-cabal-package repo for implementing typeclass instances (Functor, Applicative, Monad, etc.) on custom data types.

## Build & Test

```sh
cabal build all
cabal test --test-show-details=direct
```

## Lint & Format

```sh
fourmolu -i src/ test/
hlint src/ test/
```

## Project Structure

- `hs-exercises.cabal` — single build definition (cabal-version 3.0, GHC2021)
- `src/Exercises/*.hs` — exercise modules (e.g. `Exercises.MyMaybe`, `Exercises.MyList`)
- `test/Exercises/*Spec.hs` — hspec tests, auto-discovered via `hspec-discover`
- `test/Main.hs` — test driver (do not edit, single-line hspec-discover pragma)

## Adding a New Exercise

1. Create `src/Exercises/Foo.hs` with `module Exercises.Foo where`
2. Add `Exercises.Foo` to `exposed-modules` in `hs-exercises.cabal`
3. Create `test/Exercises/FooSpec.hs` and add to `other-modules` in the test suite
4. Run `cabal build all` to verify

## Conventions

- GHC 9.12.x, cabal-install 3.14+
- Default extensions: `DerivingStrategies`, `LambdaCase`, `OverloadedStrings`
- Warnings: `-Wall -Wcompat -Wincomplete-record-updates -Wincomplete-uni-patterns -Wredundant-constraints -Wunused-packages`
- Formatter config: `fourmolu.yaml` (2-space indent, leading commas)
- Linter config: `.hlint.yaml`
