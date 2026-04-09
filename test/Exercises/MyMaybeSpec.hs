{-# OPTIONS_GHC -Wno-type-defaults #-}

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
