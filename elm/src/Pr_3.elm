module Pr_3 exposing (..)

import Html exposing (text)

main =
    text
        <| String.fromInt
        --<| fact2 5
        --<| depth (Leaf 5)
        --<| depth (Node (Leaf 5) Empty)
        --<| depth (Node (Leaf 5) (Leaf 4))
        --<| depth (Node (Leaf 5) (Node (Leaf 4) (Leaf 2)))
        --<| count (Node (Leaf 5) (Node (Leaf 4) Empty))
        <| sum (Node (Leaf 5) (Node (Leaf 4) Empty))


fact: Int -> Int
fact n =
    case n of
        0 -> 1
        _ -> n * fact (n - 1)

fact2: Int -> Int
fact2 n =
    let
        fa m result =
            case m of
                0 -> result
                _ -> fa (m - 1) (result * m)
    in
        fa n 1

--listToString: (a -> String) -> List a -> String
--listToString fnc list =
    --let
        --lts f li =
            --[] -> ""
            --first :: rest ->
                --(f first)
                --++ if rest == [] then "" else ", "
                --++ lts f rest
    --in
--        

type Tree a = Empty
    | Leaf a
    | Node (Tree a) (Tree a)

depth tree = 
    case tree of
        Empty -> 0
        Leaf _ -> 1
        Node l r -> 1 + (max (depth l) (depth r))

count tree =
    case tree of
        Empty -> 0
        Leaf _ -> 1
        Node l r -> (count l) + (count r)

sum tree =
    case tree of
        Empty -> 0
        Leaf n -> n
        Node l r -> (sum l) + (sum r)