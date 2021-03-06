module SqlSquared.Signature.JoinType where

import Prelude

import Control.Monad.Gen as Gen
import Data.Argonaut as J
import Data.Either (Either(..))
import Data.NonEmpty ((:|))

data JoinType
  = LeftJoin
  | RightJoin
  | InnerJoin
  | FullJoin

printJoinType ∷ JoinType → String
printJoinType = case _ of
  LeftJoin → "LEFT JOIN"
  RightJoin → "RIGHT JOIN"
  FullJoin → "FULL JOIN"
  InnerJoin → "INNER JOIN"

joinTypeFromString ∷ String → Either String JoinType
joinTypeFromString = case _ of
  "LEFT JOIN" → Right LeftJoin
  "RIGHT JOIN" → Right RightJoin
  "FULL JOIN" → Right FullJoin
  "INNER JOIN" → Right InnerJoin
  _ → Left "This is not join type"

derive instance eqJoinType ∷ Eq JoinType
derive instance ordJoinType ∷ Ord JoinType

instance encodeJsonJoinType ∷ J.EncodeJson JoinType where
  encodeJson jt =
    "tag" J.:= "join type"
    J.~> "value" J.:= printJoinType jt
    J.~> J.jsonEmptyObject

instance decodeJsonJoinType ∷ J.DecodeJson JoinType where
  decodeJson = J.decodeJson >=> \obj → do
    tag ← obj J..? "tag"
    unless (tag == "join type")
      $ Left "This is not join type"
    (obj J..? "value") >>= joinTypeFromString

genJoinType ∷ ∀ m. Gen.MonadGen m ⇒ m JoinType
genJoinType = Gen.elements $ LeftJoin :| [ RightJoin, InnerJoin, FullJoin ]
