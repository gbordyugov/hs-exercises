module Exercises.MyList where


data MyList a
  = MyNil
  | MyCons a (MyList a)
  deriving stock (Show, Eq)


myFoldr :: (a -> b -> b) -> b -> MyList a -> b
myFoldr _ z MyNil = z
myFoldr f z (MyCons a as) = f a (myFoldr f z as)


fromList :: [a] -> MyList a
fromList as = foldr MyCons MyNil as


flatten :: MyList (MyList a) -> MyList a
flatten lists = myFoldr (<>) MyNil lists


-- You'll need this for Applicative and Monad
instance Semigroup (MyList a) where
  MyNil <> x = x
  x <> MyNil = x
  MyCons h1 t1 <> x = MyCons h1 $ t1 <> x


instance Monoid (MyList a) where
  mempty = MyNil


instance Functor MyList where
  fmap _ MyNil = MyNil
  fmap f (MyCons h t) = MyCons (f h) (fmap f t)


instance Applicative MyList where
  pure x = MyCons x MyNil
  MyNil <*> _ = MyNil
  _ <*> MyNil = MyNil
  MyCons _ _ <*> MyCons _ _ = undefined
  -- (<*>) = undefined


instance Monad MyList where
  (>>=) = undefined
