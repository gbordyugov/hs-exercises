# Haskell Exercises — Project Layout

## Toolset

| Tool | Purpose |
|------|---------|
| **GHCup** | Install and manage GHC, cabal, HLS |
| **GHC 9.12.x** | Compiler (latest stable series) |
| **cabal-install 3.14+** | Build tool (the standard; Stack is no longer recommended for new projects) |
| **HLS** (Haskell Language Server) | IDE support via LSP |
| **fourmolu** | Code formatter (community default, Ormolu fork with config) |
| **hlint** | Linter |

Install everything via GHCup:

```sh
ghcup install ghc 9.12.2
ghcup install cabal 3.14.2.0
ghcup install hls 2.13.0.0
```

## Directory Structure

```
hs-exercises/
├── hs-exercises.cabal        # Build definition (single source of truth)
├── cabal.project             # Project-level cabal settings
├── .ghcup.env                # (optional) Pin toolchain versions
├── fourmolu.yaml             # Formatter config
├── .hlint.yaml               # Linter config
├── .gitignore
│
├── src/                      # Library modules (your exercise code)
│   └── Exercises/
│       ├── MyMaybe.hs        # e.g. your own Maybe with Functor/Applicative/Monad
│       ├── MyList.hs         # e.g. your own List type
│       ├── MyEither.hs
│       └── ...
│
└── test/                     # Tests
    ├── Main.hs               # Test driver
    └── Exercises/
        ├── MyMaybeSpec.hs
        ├── MyListSpec.hs
        └── ...
```

All exercise files live under `src/Exercises/`. Each file defines its own
module (e.g. `module Exercises.MyMaybe where`). This keeps things loosely
coupled — each file is self-contained, but they share a single build
definition so you get fast rebuilds and a unified test suite.

## File: `hs-exercises.cabal`

This is the **only** build definition file. Cabal is the standard build
system; a separate `package.yaml` (hpack) is unnecessary.

```cabal
cabal-version: 3.0
name:          hs-exercises
version:       0.1.0.0
synopsis:      Haskell exercises — monads, applicatives, and friends
license:       NONE
build-type:    Simple

common defaults
  default-language: GHC2021
  ghc-options:
    -Wall
    -Wcompat
    -Wincomplete-record-updates
    -Wincomplete-uni-patterns
    -Wredundant-constraints
    -Wunused-packages
  default-extensions:
    DerivingStrategies
    LambdaCase
    OverloadedStrings

library
  import:         defaults
  hs-source-dirs: src
  build-depends:    base >=4.19 && <5
  exposed-modules:
    Exercises.MyMaybe
    Exercises.MyList

test-suite tests
  import:         defaults
  type:           exitcode-stdio-1.0
  hs-source-dirs: test
  main-is:        Main.hs
  other-modules:
    Exercises.MyMaybeSpec
    Exercises.MyListSpec
  build-depends:
    , base          >=4.19 && <5
    , hs-exercises
    , hspec         >=2.11
  build-tool-depends:
    hspec-discover:hspec-discover
```

### Notes on the cabal file

- **`cabal-version: 3.0`** — enables `common` stanzas and `build-tool-depends`.
- **`GHC2021`** — the modern language edition. Turns on a curated set of
  extensions (ScopedTypeVariables, FlexibleContexts, FlexibleInstances, etc.)
  so you rarely need `{-# LANGUAGE ... #-}` pragmas.
- **`common defaults`** stanza — shared settings. Both library and test suite
  import it, so warnings stay consistent.
- **`-Wunused-packages`** — catches stale dependencies early.
- **`hspec-discover`** — auto-discovers `*Spec.hs` test modules, so you
  don't have to wire them up manually.
- **`base` is listed in both library and test suite** — with
  `cabal-version: 3.0`, every component must declare its own dependencies
  explicitly; `base` is never implicitly available.

When you add a new exercise file:

1. Create `src/Exercises/Foo.hs`
2. Add `Exercises.Foo` to `exposed-modules` in the cabal file
3. (Optional) Create `test/Exercises/FooSpec.hs` and add it to `other-modules`

## File: `cabal.project`

```
packages: .

-- Speed up builds by using parallel jobs
jobs: $ncpus

-- Keep build artifacts out of the source tree
-- (default is dist-newstyle/, which is fine)
```

This file is where you'd add project-wide settings like extra package
repositories, source-repository-packages, or flag overrides. For a single-
package exercise project, it can be minimal.

## File: `fourmolu.yaml`

```yaml
indentation: 2
comma-style: leading
record-brace-space: false
indent-wheres: false
diff-friendly-import-export: true
respectful: true
haddock-style: multi-line
newlines-between-decls: 1
```

## File: `.hlint.yaml`

```yaml
# Start permissive; tighten as you learn
- ignore: {name: "Use newtype deriving"}
- ignore: {name: "Eta reduce"}
```

## File: `.gitignore`

```
dist-newstyle/
.ghc.environment.*
*.hi
*.o
*.dyn_hi
*.dyn_o
*~
.hie/
```

## File: `src/Exercises/MyMaybe.hs` (starter)

```haskell
module Exercises.MyMaybe where

data MyMaybe a
  = MyNothing
  | MyJust a
  deriving stock (Show, Eq)

-- Exercise: implement these instances

instance Functor MyMaybe where
  fmap = undefined

instance Applicative MyMaybe where
  pure = undefined
  (<*>) = undefined

instance Monad MyMaybe where
  (>>=) = undefined
```

## File: `src/Exercises/MyList.hs` (starter)

```haskell
module Exercises.MyList where

data MyList a
  = MyNil
  | MyCons a (MyList a)
  deriving stock (Show, Eq)

-- You'll need this for Applicative and Monad
instance Semigroup (MyList a) where
  (<>) = undefined

instance Monoid (MyList a) where
  mempty = undefined

instance Functor MyList where
  fmap = undefined

instance Applicative MyList where
  pure = undefined
  (<*>) = undefined

instance Monad MyList where
  (>>=) = undefined
```

## File: `test/Main.hs`

```haskell
{-# OPTIONS_GHC -F -pgmF hspec-discover #-}
```

That single pragma line auto-discovers all `*Spec.hs` files in the test tree.

## File: `test/Exercises/MyMaybeSpec.hs` (starter)

```haskell
module Exercises.MyMaybeSpec (spec) where

import Exercises.MyMaybe
import Test.Hspec

spec :: Spec
spec = do
  describe "Functor MyMaybe" $ do
    it "fmaps over MyJust" $
      fmap (+ 1) (MyJust 2) `shouldBe` MyJust 3

    it "fmaps over MyNothing" $
      fmap (+ 1) MyNothing `shouldBe` (MyNothing :: MyMaybe Int)

  describe "Applicative MyMaybe" $ do
    it "wraps a value with pure" $
      pure 42 `shouldBe` MyJust 42

    it "applies function in MyJust" $
      (MyJust (+ 1) <*> MyJust 2) `shouldBe` MyJust 3

    it "applies MyNothing function to MyJust" $
      (MyNothing <*> MyJust 2) `shouldBe` (MyNothing :: MyMaybe Int)

    it "applies MyJust function to MyNothing" $
      (MyJust (+ 1) <*> MyNothing) `shouldBe` (MyNothing :: MyMaybe Int)

  describe "Monad MyMaybe" $ do
    it "binds MyJust" $
      (MyJust 2 >>= \x -> MyJust (x + 1)) `shouldBe` MyJust 3

    it "binds MyNothing" $
      (MyNothing >>= \x -> MyJust (x + 1 :: Int)) `shouldBe` MyNothing
```

## File: `test/Exercises/MyListSpec.hs` (starter)

```haskell
module Exercises.MyListSpec (spec) where

import Exercises.MyList
import Test.Hspec

spec :: Spec
spec = do
  describe "Functor MyList" $ do
    it "fmaps over a list" $
      fmap (+ 1) (MyCons 1 (MyCons 2 MyNil)) `shouldBe` MyCons 2 (MyCons 3 MyNil)

    it "fmaps over MyNil" $
      fmap (+ 1) MyNil `shouldBe` (MyNil :: MyList Int)

  describe "Applicative MyList" $ do
    it "wraps a value with pure" $
      pure 42 `shouldBe` MyCons 42 MyNil

    it "applies functions to values" $
      (MyCons (+ 1) (MyCons (* 10) MyNil) <*> MyCons 2 (MyCons 3 MyNil))
        `shouldBe` MyCons 3 (MyCons 4 (MyCons 20 (MyCons 30 MyNil)))

    it "applies MyNil functions" $
      (MyNil <*> MyCons 1 MyNil) `shouldBe` (MyNil :: MyList Int)

    it "applies functions to MyNil" $
      (MyCons (+ 1) MyNil <*> MyNil) `shouldBe` (MyNil :: MyList Int)

  describe "Monad MyList" $ do
    it "binds over a list" $
      (MyCons 1 (MyCons 2 MyNil) >>= \x -> MyCons x (MyCons (x * 10) MyNil))
        `shouldBe` MyCons 1 (MyCons 10 (MyCons 2 (MyCons 20 MyNil)))

    it "binds over MyNil" $
      (MyNil >>= \x -> MyCons (x + 1 :: Int) MyNil) `shouldBe` MyNil
```

## Workflow

```sh
# Build everything
cabal build all

# Run tests (recompiles only what changed)
cabal test --test-show-details=direct

# Load a module in GHCi for interactive exploration
cabal repl lib:hs-exercises
# then :load Exercises.MyMaybe

# Format
fourmolu -i src/ test/

# Lint
hlint src/ test/
```

## Adding a New Exercise

Once the basics are in place, `Foldable` and `Traversable` are natural next
exercises for both `MyMaybe` and `MyList`.

1. `cp src/Exercises/MyMaybe.hs src/Exercises/MyState.hs`
2. Edit the module name and types
3. Add `Exercises.MyState` to `exposed-modules` in `.cabal`
4. Optionally add a `test/Exercises/MyStateSpec.hs` and list it in `other-modules`
5. `cabal build all` to verify
