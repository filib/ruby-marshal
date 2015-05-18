{-# LANGUAGE OverloadedStrings #-}

module GetSpec (spec) where

import Data.Ruby.Marshal.Get
import Test.Hspec

import Data.Serialize.Get (runGet)

import qualified Data.ByteString as BS

nil :: BS.ByteString
nil = BS.pack [48]

true :: BS.ByteString
true = BS.pack [84]

false :: BS.ByteString
false = BS.pack [70]

float :: BS.ByteString
float = BS.pack [18, 51, 46, 49, 52, 49, 53, 57, 50, 54, 53, 51, 53, 57]

spec :: Spec
spec = describe "getNil" $ do
  context "when we have nil" $
    it "should parse" $ do
      runGet getNil nil `shouldBe` Right ()

  context "when we have true" $
    it "should parse" $ do
      runGet getBool true `shouldBe` Right True

  context "when we have false" $
    it "should parse" $ do
      runGet getBool false `shouldBe` Right False

  context "when we have PI" $
    it "should parse" $ do
      runGet getFloat float `shouldBe` Right 3.14159265359
