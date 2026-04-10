module Exercises.Identity where


newtype Identity a = Identity a


instance (Semigroup a) => Semigroup (Identity a) where
  Identity a <> Identity b = Identity $ a <> b


instance (Monoid a) => Monoid (Identity a) where
  mempty = Identity $ mempty



instance Functor Identity where
  fmap fab (Identity a) = Identity $ fab a



instance Applicative Identity where
  pure = Identity
  Identity fab <*> Identity a = Identity $ fab a



instance Monad Identity where
  Identity a >>= faib = faib a
