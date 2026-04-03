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
