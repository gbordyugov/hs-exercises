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
