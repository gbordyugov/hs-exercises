module Exercises.MyMaybeT where

newtype MyMaybeT m a = MyMaybeT { runMyMaybeT :: m (Maybe a) }


instance (Semigroup m) => Semigroup (MyMaybeT m a) where
  (<>) = undefined


instance (Monoid m) => Monoid (MyMaybeT m a) where
  mempty = undefined


instance (Functor m) => Functor (MyMaybeT m) where
  fmap = undefined
  

instance (Applicative m) => Applicative (MyMaybeT m) where
  (<*>) = undefined


instance (Monad m) => Monad (MyMaybeT m) where
  (>>=) = undefined
