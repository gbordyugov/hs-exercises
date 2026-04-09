module Exercises.Composition where

newtype Composition f g a = Composition { runComposition :: f (g a) }
