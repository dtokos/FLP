module BSTTests exposing (..)

-- Dobroslav Tokoš
-- Testy sú písané pomocou elm-test knižnice (https://www.npmjs.com/package/elm-test).
-- V mojom projekte nachádzajú v inej zložke ako projekt! K jejich spusteniu je treba mať vytvorený elm projekt (elm init).
-- Následne treba inicializovať testy (elm-test init). Zrojové súbory musia byť vo zložke src a testy vo zložke tests.
-- Potom by sa mali dať testy pustiť (elm-test).

-- Teto testy som písal hlavne preto lebo som sa o jednej ráno trápil s binárnym vymazávaním. Kvôli únave som si nebol na 100% istý či som to implementoval správne.
-- Preto som napísal testy ktoré testujú funkcionalitu binárneho stromu. Keďže sú kľúče stringy tak si treba uvedomiť že: "9" > "53" == True

import Expect exposing (Expectation)
import Test exposing (..)
import Zadanie exposing (BST(..), bstInsert, bstReduce, bstFind, bstRemove)
import List exposing (foldl)

insertTests: Test
insertTests =
    describe "BST insert" [
        test "Insert into empty tree"
            (\_ -> Expect.equal
                (bstInsert "1" "1" EmptyNode)
                (Node "1" "1" EmptyNode EmptyNode)),
        test "Insert left"
            (\_ -> Expect.equal
                (bstInsert "1" "1" (Node "2" "2" EmptyNode EmptyNode))
                (Node "2" "2" (Node "1" "1" EmptyNode EmptyNode) EmptyNode)),
        test "Insert right"
            (\_ -> Expect.equal
                (bstInsert "3" "3" (Node "2" "2" EmptyNode EmptyNode))
                (Node "2" "2" EmptyNode (Node "3" "3" EmptyNode EmptyNode))),
        test "Insert left left"
            (\_ -> Expect.equal
                (bstInsert "1" "1" (bstInsert "2" "2" (Node "3" "3" EmptyNode EmptyNode)))
                (Node "3" "3" (Node "2" "2" (Node "1" "1" EmptyNode EmptyNode) EmptyNode) EmptyNode)),
        test "Insert left right"
            (\_ -> Expect.equal
                (bstInsert "2" "2" (bstInsert "1" "1" (Node "3" "3" EmptyNode EmptyNode)))
                (Node "3" "3" (Node "1" "1" EmptyNode (Node "2" "2" EmptyNode EmptyNode)) EmptyNode)),
        test "Insert right left"
            (\_ -> Expect.equal
                (bstInsert "2" "2" (bstInsert "3" "3" (Node "1" "1" EmptyNode EmptyNode)))
                (Node "1" "1" EmptyNode (Node "3" "3" (Node "2" "2" EmptyNode EmptyNode) EmptyNode))),
        test "Insert right right"
            (\_ -> Expect.equal
                (bstInsert "3" "3" (bstInsert "2" "2" (Node "1" "1" EmptyNode EmptyNode)))
                (Node "1" "1" EmptyNode (Node "2" "2" EmptyNode (Node "3" "3" EmptyNode EmptyNode))))
    ]

bstFromList: List a -> BST String
bstFromList list =
    foldl (\n t -> bstInsert (Debug.toString n) (Debug.toString n) t) EmptyNode list

fromListTests: Test
fromListTests =
    describe "BST from list" [
        test "Empty list"
            (\_ -> Expect.equal
                (bstFromList [])
                (EmptyNode)),
        test "Single element"
            (\_ -> Expect.equal
                (bstFromList [1])
                (Node "1" "1" EmptyNode EmptyNode)),
        test "Multiple elements"
            (\_ -> Expect.equal
                (bstFromList [3, 6, 7, 2, 4, 5, 1, 9, 8])
                (Node "3" "3" (Node "2" "2" (Node "1" "1" EmptyNode EmptyNode) EmptyNode) (Node "6" "6" (Node "4" "4" EmptyNode (Node "5" "5" EmptyNode EmptyNode)) (Node "7" "7" EmptyNode (Node "9" "9" (Node "8" "8" EmptyNode EmptyNode) EmptyNode)))))
    ]

reduceTests: Test
reduceTests =
    let
        toStr node acc =
            case node of
                EmptyNode -> acc ++ ""
                Node k v lc rc -> acc ++ k
    in describe "BST reduce" [
        test "Empty tree"
            (\_ -> Expect.equal
                (bstReduce toStr "" EmptyNode)
                ""),
        test "Normal tree"
            (\_ -> Expect.equal
                (bstReduce toStr "" (bstFromList [3, 6, 7, 2, 4, 5, 1, 9, 8]))
                "123456789")
    ]

findTests: Test
findTests =
    describe "BST find" [
        test "Empty tree"
            (\_ -> Expect.equal
                (bstFind "1" EmptyNode)
                Nothing),
        test "Not existing key"
            (\_ -> Expect.equal
                (bstFind "1" (bstFromList [3, 6, 7, 2, 4, 5, 9, 8]))
                Nothing),
        test "Existing key"
            (\_ -> Expect.notEqual
                (bstFind "9" (bstFromList [3, 6, 7, 2, 4, 5, 9, 8]))
                Nothing)
    ]

removeTests: Test
removeTests =
    describe "BST remove" [
        test "Empty tree"
            (\_ -> Expect.equal
                (bstRemove "1" EmptyNode)
                EmptyNode),
        test "Not existing key"
            (\_ -> Expect.equal
                (bstRemove "1" (bstFromList [3, 6, 7, 2, 4, 5, 9, 8]))
                (bstFromList [3, 6, 7, 2, 4, 5, 9, 8])),
        test "Not children"
            (\_ -> Expect.equal
                (bstRemove "1" (bstFromList [1]))
                EmptyNode),
        test "Only left child"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1]))
                (bstFromList [1])),
        test "Only right child"
            (\_ -> Expect.equal
                (bstRemove "1" (bstFromList [1, 2]))
                (bstFromList [2])),
        test "Both children"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1, 3]))
                (bstFromList [3, 1])),
        test "Both children with min 1"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1, 5, 4]))
                (bstFromList [4, 1, 5])),
        test "Both children with min 2"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1, 5, 3, 4, 6]))
                (bstFromList [3, 1, 5, 4, 6])),
        test "Both children with min 3"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1, 8, 4, 6, 3, 5, 7]))
                (bstFromList [3, 1, 8, 4, 6, 5, 7])),
        test "Both children with min 4"
            (\_ -> Expect.equal
                (bstRemove "2" (bstFromList [2, 1, 8, 6, 5, 4, 7]))
                (bstFromList [4, 1, 8, 6, 5, 7])),
        test "Both children with min 5"
            (\_ -> Expect.equal
                (bstRemove "3" (bstFromList [3, 6, 7, 2, 4, 5, 1, 9, 8]))
                (bstFromList [4, 6, 7, 2, 5, 1, 9, 8]))
    ]
