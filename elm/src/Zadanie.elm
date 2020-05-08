module Zadanie exposing (..)

import Browser
import List exposing (map, filter)
import Html exposing (Html, h3, input, div, br, strong, text, button)
import Html.Attributes exposing (type_, placeholder, value)
import Html.Events exposing (..)

main =
    Browser.sandbox{init = init, update = update, view = view}

type alias Model = (State, Tables)
type alias Tables = List Table
type alias Table = (String, BST String)
type BST a = EmptyNode | Node String String (BST a)(BST a)
type alias State = {
        table: String,
        key: String,
        value: String,
        output: String
    }
type Message =
    SetTable String |
    SetKey String |
    SetValue String |
    NewOrEmpty |
    Insert |
    Show |
    ShowRep

init: Model
init = (clearState "", [("foo", Node "a" "42" EmptyNode EmptyNode)])

update: Message -> Model -> Model
update message (state, tables) =
    case message of
        SetTable t ->
            ({state | table = t, output = ""}, tables)
        SetKey k ->
            ({state | key = k, output = ""}, tables)
        SetValue v ->
            ({state | value = v, output = ""}, tables)

        NewOrEmpty ->
            if state.table == "" then missingArguments "názov tabuľky" state tables
            else if (findTable state.table tables) == Nothing then (clearState ("Vytvorená nová tabuľka: " ++ state.table), newOrEmpty state.table tables)
            else (clearState ("Tabuľka " ++ state.table ++ " bola vyprázdnená"), newOrEmpty state.table tables)
        Insert ->
            if state.table == "" || state.key == "" || state.value == "" then missingArguments "názov tabuľky, kľúč a hodnotu" state tables
            else if (findTable state.table tables) == Nothing then tableNotFound state tables
            else (clearState ("Vložená hodnota '" ++ state.value ++ "' pod kľučom '" ++ state.key ++ "' do tabuľky " ++ state.table), insert state.table state.key state.value tables)
        Show ->
            if state.table == "" then missingArguments "názov tabuľky" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t -> (keepState state ("Tabuľka " ++ state.table ++ ": " ++ show t), tables)
        ShowRep ->
            if state.table == "" then missingArguments "názov tabuľky" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t -> (keepState state ("Tabuľka " ++ state.table ++ ": " ++ show t), tables)

clearState: String -> State
clearState out =
    State "" "" "" out

keepState: State -> String -> State
keepState state out =
    State state.table state.key state.value out

missingArguments: String -> State -> Tables -> Model
missingArguments missing state tables =
    (keepState state ("Zadajte " ++ missing), tables)

tableNotFound: State -> Tables -> Model
tableNotFound state tables =
    (keepState state ("Tabuľka " ++ state.table ++ " neexistuje"), tables)





view: Model -> Html Message
view (state, tables) =
    div [] [
        h3 [] [text "Zadanie"],
        htmlInput "Názov tabulky" state.table SetTable,
        br [] [],
        htmlInput "Kľúč" state.key SetKey,
        br [] [],
        htmlInput "Hodnota" state.value SetValue,
        br [] [],
        br [] [],
        button [onClick NewOrEmpty] [text "Pridať/Vyprázdniť"],
        button [onClick Insert] [text "Vložiť"],
        button [onClick Show] [text "Zobraziť"],
        br [] [],
        br [] [],
        div [] [text <| "Dostupné tabuľky: " ++ viewTables tables],
        br [] [],
        br [] [],
        strong [] [text state.output]
    ]

htmlInput: String -> String -> (String -> msg) -> Html msg
htmlInput ph val msg =
    input [type_ "text", placeholder ph, value val, onInput msg] []

viewTables: Tables -> String
viewTables tables =
    listToString Tuple.first tables

listToString: (a -> String) -> List a -> String
listToString fnc list =
    let
        lts f l =
            case l of
                [] -> ""
                first :: rest ->
                    (f first) ++ if rest == [] then "" else ", " ++ lts f rest
    in "[" ++ lts fnc list ++ "]"





newOrEmpty: String -> Tables -> Tables
newOrEmpty newName tables =
    let
        f (name, values) =
            name /= newName
    in (newName, EmptyNode) :: filter f tables

insert: String -> String -> String -> Tables -> Tables
insert table key value tables =
    let
        f (name, values) =
            if name == table then (name, (bstInsert key value values))
            else (name, values)
    in map f tables

findTable: String -> Tables -> Maybe Table
findTable table tables =
    case tables of
        [] -> Nothing
        (name, values) :: rest ->
            if name == table then Just (name, values)
            else findTable table rest

show: Table -> String
show table =
    let
        toStr node acc =
            case node of
                EmptyNode -> acc ++ ""
                Node k v lc rc ->
                    acc ++ k ++ ":" ++ v ++ if lc == EmptyNode && rc == EmptyNode then "" else ", "
    in bstPreorder toStr "" <| Tuple.second table





bstInsert: String -> String -> BST String -> BST String
bstInsert key value tree =
    case tree of
        EmptyNode -> Node key value EmptyNode EmptyNode
        Node nKey nVal nLC nRC ->
            if nKey == key then Node key value nLC nRC
            else if key < nKey then Node nKey nVal (bstInsert key value nLC) nRC
            else Node nKey nVal nLC (bstInsert key value nRC)

bstPreorder: (BST String -> b -> b) -> b -> BST String -> b
bstPreorder fnc acc tree =
    case tree of
        EmptyNode -> fnc EmptyNode acc
        Node key value lc rc ->
            bstPreorder fnc (bstPreorder fnc (fnc (Node key value lc rc) acc) lc) rc

