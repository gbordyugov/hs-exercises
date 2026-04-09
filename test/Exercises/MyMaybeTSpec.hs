{-# OPTIONS_GHC -Wno-type-defaults #-}

module Exercises.MyMaybeTSpec (spec) where

import Exercises.MyMaybeT
import Test.Hspec

spec :: Spec
spec = do
  describe "Functor MyMaybeT" $ do
    it "fmaps over Just value" $
      fmap (+ 1) (MyMaybeT [Just 2]) `shouldBe` MyMaybeT [Just 3]

    it "fmaps over Nothing" $
      fmap (+ 1) (MyMaybeT [Nothing]) `shouldBe` (MyMaybeT [Nothing] :: MyMaybeT [] Int)

    it "fmaps over multiple values" $
      fmap (+ 1) (MyMaybeT [Just 1, Nothing, Just 3])
        `shouldBe` MyMaybeT [Just 2, Nothing, Just 4]

    it "preserves identity law" $
      fmap id (MyMaybeT [Just 5, Nothing])
        `shouldBe` MyMaybeT [Just 5, Nothing]

    it "preserves composition law" $
      let x = MyMaybeT [Just 3, Nothing, Just 7]
       in fmap ((+ 1) . (* 2)) x
            `shouldBe` (fmap (+ 1) . fmap (* 2)) x
