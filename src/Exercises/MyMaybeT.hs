module Exercises.MyMaybeT where

newtype MyMaybeT m a = MyMaybeT { runMyMaybeT :: m (Maybe a) }


instance (Functor m) => Functor (MyMaybeT m) where
  fmap f (MyMaybeT mma) = MyMaybeT $ undefined


instance (Applicative m) => Applicative (MyMaybeT m) where
  pure = undefined
  (<*>) = undefined


instance (Monad m) => Monad (MyMaybeT m) where
  (>>=) = undefined
