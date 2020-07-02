module Skuska exposing (..)

import Html exposing (text)

main =
    text
        <| Debug.toString
        --<| nth [1,2,3] -1
        --<| neznama [1,2,1,3,1,5] 1
        <| neznamaFunkc [1,2,1,3,1,5] 1

nth: List a -> Int -> Maybe a
nth list n =
    case list of
        [] -> Nothing
        x :: rest ->
            if n == 0 then Just x
            else nth rest (n - 1)

neznama: List a -> a -> List Int
neznama li prv =
    case li of
        [] -> []
        first :: rest ->
            (if first == prv then 1 else 0)
            :: neznama rest prv

map: (a -> b) -> List a -> List b
map fnc list =
    case list of
        [] -> []
        x :: rest ->
            (fnc x) :: map fnc rest

neznamaSMap: List a -> a -> List Int
neznamaSMap list prv =
    map (\x -> if x == prv then 1 else 0) list
