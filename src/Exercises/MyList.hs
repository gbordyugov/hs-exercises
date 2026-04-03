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
