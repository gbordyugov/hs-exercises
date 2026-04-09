module Exercises.MyState where

newtype MyState s a = MyState { runMyState :: s -> (s, a) }

instance Functor (MyState s) where
  fmap f (MyState ssa) = MyState $ \s0 ->
    let (s, b) = ssa s0
    in (s, f b)


instance Applicative (MyState s) where
  pure x = MyState $ \s -> (s, x)
  MyState sfab <*> MyState sa = MyState $ \s0 ->
    let (s1, a) = sa s0
        (s2, fab) = sfab s1
    in (s2, fab a)

instance Monad (MyState s) where
  return = pure
  MyState ma >>= famb = MyState $ \s0 ->
    let (s1, a) = ma s0
        s2 = famb a
    in (runMyState s2) s1
