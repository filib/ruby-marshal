--------------------------------------------------------------------
-- |
-- Module    : Data.Ruby.Marshal
-- Copyright : (c) Philip Cunningham, 2015
-- License   : MIT
--
-- Maintainer:  hello@filib.io
-- Stability :  experimental
-- Portability: portable
--
-- Simple interface to parse Ruby Marshal binary.
--
--------------------------------------------------------------------

module Data.Ruby.Marshal (
  -- * Decoding
    decode
  , decodeEither
  -- * Lifting into and lowering from RubyObject
  , fromRuby
  , toRuby
  -- * Re-exported modules
  , module Data.Ruby.Marshal.Types
) where

import           Control.Monad.State.Strict   (evalStateT)
import qualified Data.ByteString              as BS
import           Data.Ruby.Marshal.Get
import           Data.Ruby.Marshal.Monad      (emptyCache, runMarshal)
import           Data.Ruby.Marshal.RubyObject
import           Data.Ruby.Marshal.Types
import           Data.Serialize               (runGet)

-- | Parses a subset of Ruby objects serialised with Marshal, Ruby's
-- built-in binary serialisation format.
decode :: BS.ByteString
       -- ^ Serialised Ruby object
       -> Maybe RubyObject
       -- ^ De-serialisation result
decode = hush . decodeEither

-- | Parses a subset of Ruby objects serialised with Marshal, Ruby's
-- built-in binary serialisation format.
decodeEither :: BS.ByteString
             -- ^ Serialised Ruby object
             -> Either String RubyObject
             -- ^ Error message or de-serialisation result
decodeEither = runGet (evalStateT (runMarshal getRubyObject) emptyCache)

-- | Converts an Either to a Maybe.
hush :: Either a b -> Maybe b
hush = either (const Nothing) Just
