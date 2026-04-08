module Exercises.MyStateSpec (spec) where

import Exercises.MyState
import Test.Hspec

spec :: Spec
spec = do
  describe "runMyState basics" $ do
    it "threads state through a simple computation" $
      runMyState (MyState $ \s -> (s + 1, s)) 0 `shouldBe` (1, 0)

  describe "Functor MyState" $ do
    it "fmaps over the result without changing state" $
      runMyState (fmap (* 10) (MyState $ \s -> (s + 1, s))) 0
        `shouldBe` (1, 0)

    it "fmaps with a different function" $
      runMyState (fmap show (MyState $ \s -> (s + 1, s))) 0
        `shouldBe` (1, "0")

    it "fmap id is identity" $
      runMyState (fmap id (MyState $ \s -> (s + 1, 42 :: Int))) 0
        `shouldBe` (1, 42)

  describe "Applicative MyState" $ do
    it "pure leaves state unchanged" $
      runMyState (pure 42 :: MyState Int Int) 0 `shouldBe` (0, 42)

    it "applies a stateful function to a stateful value" $
      let sf = MyState $ \s -> (s + 1, (+ 10))
          sa = MyState $ \s -> (s + 1, 5 :: Int)
      in runMyState (sf <*> sa) 0 `shouldBe` (2, 15)

    it "sequences state changes left to right through <*>" $
      let sf = MyState $ \s -> (s ++ "f", (++ "!"))
          sa = MyState $ \s -> (s ++ "a", "hello")
      in runMyState (sf <*> sa) "" `shouldBe` ("af", "hello!")

  describe "Monad MyState" $ do
    it "return leaves state unchanged" $
      runMyState (return 42 :: MyState Int Int) 0 `shouldBe` (0, 42)

    it "binds two state computations" $
      let m = MyState $ \s -> (s + 1, s)
          f x = MyState $ \s -> (s + 1, x + s)
      in runMyState (m >>= f) 0 `shouldBe` (2, 1)

    it "chains multiple binds" $
      let get = MyState $ \s -> (s, s)
          put s = MyState $ \_ -> (s, ())
          m = get >>= \s -> put (s + 10) >>= \_ -> get
      in runMyState m 0 `shouldBe` (10, 10)
