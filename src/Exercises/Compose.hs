module Exercises.Compose where


newtype Compose f g a = Compose { runCompose :: f (g a) }


instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap fab (Compose fga) = Compose $ fmap (fmap fab) fga


instance (Applicative s, Applicative t) => Applicative (Compose s t) where
  pure = Compose . pure . pure
  Compose stfab <*> Compose sta = Compose $ liftA2 (<*>) stfab sta
