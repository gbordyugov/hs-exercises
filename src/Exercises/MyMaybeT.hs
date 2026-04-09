{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UndecidableInstances #-}

module Exercises.MyMaybeT where

newtype MyMaybeT m a = MyMaybeT { runMyMaybeT :: m (Maybe a) }

deriving instance (Eq (m (Maybe a))) => Eq (MyMaybeT m a)
deriving instance (Show (m (Maybe a))) => Show (MyMaybeT m a)


instance (Functor m) => Functor (MyMaybeT m) where
  fmap f (MyMaybeT mma) = MyMaybeT $ fmap (fmap f) mma


instance (Applicative m) => Applicative (MyMaybeT m) where
  pure = undefined
  (<*>) = undefined


instance (Monad m) => Monad (MyMaybeT m) where
  (>>=) = undefined
