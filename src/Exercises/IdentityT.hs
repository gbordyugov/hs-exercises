module Exercises.IdentityT where

import Exercises.Identity


newtype IdentityT m a = IdentityT { runIdentityT :: m (Identity a) }


instance (Functor m) => Functor (IdentityT m) where
  fmap fab (IdentityT mia) = IdentityT $ fmap (fmap fab) mia


instance (Applicative m) => Applicative (IdentityT m) where
  pure x = IdentityT $ pure (Identity x)
  IdentityT mfab <*> IdentityT ma = IdentityT $ liftA2 (<*>) mfab ma


instance (Monad m) => Monad (IdentityT m) where
  IdentityT mia >>= faimib = undefined

