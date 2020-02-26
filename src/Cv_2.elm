module Cv_2 exposing (..)

import Html exposing (text)
import List exposing (filter)

main =
    text
        <| Debug.toString
        ---<| length [1, 2, 3]
        ---<| lengthFold [1, 2, 3]
        ---<| member 5 [1, 2, 3]
        ---<| countBigger 2 [1, 2, 3, 4, 0]
        ---<| smaller 2 [1, 2, 3, 4, 7, 0]
        ---<| smallerRec 2 [1, 2, 3, 4, 7, 0]
        ---<| afterElem 2 [1, 2, 3, 4, 0]
        ---<| zip ['a', 'b', 'c'] [1, 2, 3, 4, 0]
        ---<| map ((+) 5) [1, 2, 3, 4, 0]
        ---<| fromTuple String.fromInt identity (3, "aaa")
        ---<| foldl (+) 0 [1, 2, 3]
        ---<| foldr (+) 0 [1, 2, 3, 4]
        ---<| foldl (::) [] [1, 2, 3, 4]
        <| foldr (::) [] [1, 2, 3, 4]

length: List a -> Int
length list =
    case list of
        [] -> 0
        first :: rest ->
            1 + length rest

lengthFold: List a -> Int
lengthFold list =
    foldl (\ a b -> b + 1) 0 list

member: a -> List a -> Bool
member el list =
    case list of
        [] -> False
        first :: rest ->
            if first == el then
                True
            else
                member el rest

countBigger: comparable -> List comparable -> Int
countBigger el list =
    lengthFold
        <| filter (\ a -> a > el) list

smaller: comparable -> List comparable -> List comparable
smaller el list =
    filter (\ a -> a < el) list

smallerRec: comparable -> List comparable -> List comparable
smallerRec el list =
    case list of
        [] -> []
        first :: rest ->
            if first < el then
                first :: smallerRec el rest
            else
                smallerRec el rest

afterElem : a -> List a -> List a
afterElem el list =
    case list of
        [] -> []
        first :: rest ->
            if el == first then
                rest
            else
                afterElem el rest

zip: List a -> List b -> List (a, b)
zip listA listB =
    case listA of
        [] -> []
        firstA :: restA ->
            case listB of
                [] -> []
                firstB :: restB ->
                    (firstA, firstB) :: zip restA restB

map: (a -> b) -> List a -> List b
map fnc list =
    case list of
        [] -> []
        first :: rest ->
            fnc first :: map fnc rest

fromTuple: (a -> String) -> (b -> String) -> (a, b) -> String
fromTuple fnc1 fnc2 (a, b) =
    "(" ++ fnc1 a ++ "," ++ fnc2 b ++ ")"

foldl: (a -> b -> b) -> b -> List a -> b
foldl fnc acc list =
    case list of
        [] -> acc
        first :: rest ->
            foldl fnc (fnc first acc) rest

foldr: (a -> b -> b) -> b -> List a -> b
foldr fnc acc list =
    case list of
        [] -> acc
        first :: rest ->
            fnc first (foldr fnc acc rest)