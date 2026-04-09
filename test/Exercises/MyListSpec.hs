module Exercises.MyListSpec (spec) where

import Exercises.MyList
import Test.Hspec


spec :: Spec
spec = do
  describe "myFoldr on MyList" $ do
    it "sums up correctly an empty list" $
      myFoldr (+) 0 (fromList []) `shouldBe` 0

    it "multiplies up correctly an empty list" $
      myFoldr (*) 1 (fromList []) `shouldBe` 1

    it "sums up correctly list with one element" $
      myFoldr (+) 0 (fromList [1]) `shouldBe` 1

    it "sums up correctly list with two element" $
      myFoldr (+) 0 (fromList [1, 2])`shouldBe` 3

    it "sums up correctly list with three element" $
      myFoldr (+) 0 (fromList [1, 2, 3]) `shouldBe` 6

    it "multiplies correctly list with one element" $
      myFoldr (*) 1 (fromList [2]) `shouldBe` 2

    it "multiplies correctly list with two element" $
      myFoldr (*) 1 (fromList [2, 3]) `shouldBe` 6

    it "multiplies correctly list with three element" $
      myFoldr (*) 1 (fromList [2, 3, 4]) `shouldBe` 24

  describe "fromList" $ do
    it "correctly converts an empty list" $
      fromList ([] :: [Int]) `shouldBe` (MyNil :: MyList Int)

    it "correctly converts a list with one element" $
      fromList [1] `shouldBe` MyCons 1 MyNil

    it "correctly converts a list with two elements" $
      fromList [1, 2] `shouldBe` MyCons 1 (MyCons 2 MyNil)

    it "correctly converts a list with three elements" $
      fromList [1, 2, 3] `shouldBe` MyCons 1 (MyCons 2 (MyCons 3 MyNil))

  describe "Functor MyList" $ do
    it "fmaps over a list" $
      fmap (+ 1) (fromList [1, 2]) `shouldBe` fromList [2, 3]

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
