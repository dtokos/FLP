module Pr_1 exposing (..)

import Html exposing (text)

main =
    text <| String.fromInt (plus7 10)
    --text <| String.fromInt ((+) 5 10)  --Definicia operatora ako funkcie

plus : Int -> Int -> Int
plus a b = a + b

plus5 : Int -> Int
plus5 a = plus a 5

plus7 : Int -> Int
plus7 = plus 7
