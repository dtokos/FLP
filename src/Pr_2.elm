module Pr_2 exposing (..)

import Html exposing (text)

main =
    text ---<| String.fromInt
        ---<| fakt 5
        ---<| nsd 36 20
        ---<| fromListInt [36, 20, 5]
        ---<| fromListChar ['a', 'b', 'c']
        ---<| fromList String.fromChar ['a', 'b', 'c']
        ---<| fromList String.fromInt [36, 20, 5]
        <| fromList String.fromInt
        <| map (\ a -> a + 1) [4, 5, 6]
    
fakt: Int -> Int
fakt n =
     case n of
         0 -> 1
         _ -> n * fakt (n - 1)
         

nsd: Int -> Int -> Int
nsd n1 n2 =
    if n1 == n2 then
        n1
    else if n1 < n2 then
        nsd n1 (n2 - n1)
    else
        nsd n2 (n1 - n2)
        
fromListInt: List Int -> String
fromListInt list = 
    case list of
        [] -> ""
        first :: rest ->
            String.fromInt first ++
            if rest == [] then "" else ", " ++
            fromListInt rest
            
fromListChar: List Char -> String
fromListChar list = 
    case list of
        [] -> ""
        first :: rest ->
            String.fromChar first ++
            if rest == [] then "" else ", " ++
            fromListChar rest
            
fromList: (a -> String) -> List a -> String
fromList fnc list = 
    let fromL f l =
        case l of
            [] -> ""
            first :: rest ->
                f first ++
                if rest == [] then "" else ", " ++
                fromL f rest
    in
        "[" ++ fromL fnc list ++ "]"
        

map: (a -> b) -> List a -> List b
map fnc list = 
    case list of
        [] -> []
        first :: rest -> fnc first :: map fnc rest
