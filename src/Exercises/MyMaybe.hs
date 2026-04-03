module Exercises.MyMaybe where

data MyMaybe a
  = MyNothing
  | MyJust a
  deriving stock (Show, Eq)

-- Exercise: implement these instances

instance Functor MyMaybe where
  fmap _ MyNothing = MyNothing
  fmap f (MyJust x) = MyJust $ f x


instance Applicative MyMaybe where
  pure = MyJust
  MyNothing <*> _ = MyNothing
  _ <*> MyNothing = MyNothing
  MyJust f <*> MyJust a = MyJust $ f a


instance Monad MyMaybe where
  MyNothing >>= _ = MyNothing
  MyJust x >>= f = f x
