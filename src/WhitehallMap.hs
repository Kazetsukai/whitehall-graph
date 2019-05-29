module WhitehallMap where

import Data.List
import Data.Char
import Data.Graph.Inductive
import Data.Graph.Inductive.Dot

data WNode = JackNode String | InspectorNode String    deriving Show

num2letters n
    | n >= 26   = num2letters (n `div` 26 - 1) ++ num2letters (n `mod` 26)
    | n >= 0    = [chr $ (ord 'A') + n]
    | otherwise = "_"

jackNodes = map (\n -> (n, JackNode $ show n)) [1..189]
inspectorNodes = map (\n -> (n + length jackNodes, InspectorNode $ num2letters n)) [0..174]

isJackNode (JackNode _) = True
isJackNode _ = False
isInspectorNode (InspectorNode _) = True
isInspectorNode _ = False

streetEdges = concatMap (\s -> [(fst s, snd s, "street"), (snd s, fst s, "street")]) streets

compressEdges :: Eq b => Context a b -> [LEdge b]
compressEdges (i, _, _, o) = [(a, b, l) | (l, a) <- i, (l2, b) <- o, a /= b, l == l2]

whitehallMap :: Gr WNode String
whitehallMap = mkGraph (jackNodes ++ inspectorNodes) streetEdges

inspectorMoveMap m = insEdges (nub $ concat $ map compressEdges contextsToDelete) $ delNodes nodesToDelete m
    where nodesToDelete = map (\(_, n, _, _) -> n) contextsToDelete
          contextsToDelete = gsel (\(_, _, l, _) -> isJackNode l) m


streets = [
    (1,189),(1,202),
    (2,191),(2,192),(2,193),
    (3,194),(3,195),(3,196),
    (4,196),(4,197),
    (5,197),(5,198),

    (9,189),(9,202)
  ]