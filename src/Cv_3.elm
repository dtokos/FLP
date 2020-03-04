module Cv_3 exposing (..)

import Html exposing (text)
import List exposing (map, filter, foldl, foldr)

main =
    text
        <| Debug.toString
        --<| recSum 1000000000 1000
        --<| convIfEven [1, 2, 3, 4, 5]
        --<| convIfEvenHOF [1, 2, 3, 4, 5]
        --<| between 2 7 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        --<| betweenHOF 2 7 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        --<| depth (Value 10 (Value 5 Empty Empty) (Value 15 Empty (Value 4 Empty Empty)))
        --<| count (Value 10 (Value 5 Empty Empty) (Value 15 Empty (Value 4 Empty Empty)))
        --<| isIn 999 (Value 10 (Value 5 Empty Empty) (Value 15 Empty (Value 4 Empty Empty)))
        --<| isInBST 15 (Value 10 (Value 5 Empty Empty) (Value 15 Empty (Value 4 Empty Empty)))
        --<| insert 4 (Value 10 (Value 5 Empty Empty) (Value 15 Empty (Value 4 Empty Empty)))
        --<| bstFromList [1, 8, 3, 7, 2, 4]
        --<| bstFromListHOF [1, 8, 3, 7, 2, 4]
        <| preorder (bstFromListHOF [1, 8, 3, 7, 2, 4])

recSum: number -> number -> number
recSum n r =
    if n <= 0
    then r
    else recSum (n - 1) (r + 1)

convIfEven: List Int -> List (Int, Bool)
convIfEven list =
    case list of
        [] -> []
        first :: rest ->
            (first, modBy 2 first == 0) :: convIfEven rest

convIfEvenHOF: List Int -> List (Int, Bool)
convIfEvenHOF list =
    map (\ n -> (n, modBy 2 n == 0)) list

between: number -> number -> List number -> List number
between min max list =
    case list of
        [] -> []
        first :: rest ->
            if min <= first && first <= max
            then first :: between min max rest
            else between min max rest

betweenHOF: number -> number -> List number -> List number
betweenHOF min max list =
    filter (\ n -> min <= n && n <= max) list

type BST number = Empty
    | Value number (BST number) (BST number)

depth: BST number -> Int
depth tree =
    case tree of
        Empty -> 0
        Value _ l r -> 1 + max (depth l) (depth r)

count: BST number -> Int
count tree =
    case tree of
        Empty -> 0
        Value _ l r -> 1 + (count l) + (count r)

isIn: number -> BST number -> Bool
isIn number tree =
    case tree of
        Empty -> False
        Value v l r ->
            if v == number
            then True
            else (isIn number l) || (isIn number r)

isInBST: number -> BST number -> Bool
isInBST number tree =
    case tree of
        Empty -> False
        Value v l r ->
            if v == number
            then True
            else if number < v
            then isInBST number l
            else isInBST number r

insert: number -> BST number -> BST number
insert num tree =
    case tree of
        Empty -> (Value num Empty Empty)
        Value v l r ->
            if num == v
            then tree
            else if num < v
            then Value v (insert num l) r
            else Value v l (insert num r)

bstFromList: List number -> BST number
bstFromList list =
    case list of
        [] -> Empty
        first :: rest ->
            insert first (bstFromList rest)

bstFromListHOF: List number -> BST number
bstFromListHOF list =
    foldr insert Empty list

preorder: BST number -> List number
preorder tree =
    case tree of
        Empty -> []
        Value v l r ->
            (preorder l) ++ v :: preorder r
