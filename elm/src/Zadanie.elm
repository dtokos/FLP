module Zadanie exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
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
    Show

init: Model
init = (State "" "" "" "", [("foo", Node "a" "42" EmptyNode EmptyNode)])

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
            if state.table == "" then (State "" "" "" "Zadajte názov tabulky", tables)
            else if (findTable state.table tables) == Nothing then (State "" "" "" ("Vytvorená nová tabuľka: " ++ state.table), newOrEmpty state.table tables)
            else (State "" "" "" ("Tabuľka " ++ state.table ++ " bola vyprázdnená"), newOrEmpty state.table tables)
        Insert ->
            if state.table == "" || state.key == "" || state.value == "" then (State "" "" "" "Zadajte názov tabuľky, kľúč a hodnotu", tables)
            else if (findTable state.table tables) == Nothing then (State state.table state.key state.value ("Tabuľka " ++ state.table ++ " neexistuje"), tables)
            else (State "" "" "" ("Vložená hodnota '" ++ state.value ++ "' pod kľučom '" ++ state.key ++ "' do tabuľky " ++ state.table), insert state.table state.key state.value tables)
        Show ->
            if state.table == "" then (State "" "" "" "Zadajte názov tabuľky", tables)
            else
                let
                    t = findTable state.table tables
                in
                    case t of
                        Nothing -> (State state.table state.key state.value ("Tabuľka " ++ state.table ++ " neexistuje"), tables)
                        Just asd -> (State state.table state.key state.value ("Tabuľka " ++ state.table ++ ": " ++ show asd), tables)


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
    in
        "[" ++ lts fnc list ++ "]"

newOrEmpty: String -> Tables -> Tables
newOrEmpty newName tables =
    case tables of
        [] -> [(newName, EmptyNode)]
        (name, bst) :: rest ->
            if name == newName then (name, EmptyNode) :: rest
            else (name, bst) :: newOrEmpty newName rest

insert: String -> String -> String -> Tables -> Tables
insert table key value tables =
    case tables of
        [] -> []
        (name, values) :: rest ->
            if name == table then (name, (bstInsert key value values)) :: rest
            else (name, values) :: insert table key value rest

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
        toStr node =
            case node of
                EmptyNode -> ""
                Node k v lc rc ->
                    k ++ ":" ++ v ++ if lc == EmptyNode && rc == EmptyNode then "" else ", "
    in
        bstPreorder (\ n s -> s ++ toStr n) "" <| Tuple.second table

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

