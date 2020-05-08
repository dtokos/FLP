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
    ShowRep |
    IsIn |
    Value

init: Model
init = (clearState "", [("foo", Node "a" "1" EmptyNode (Node "d" "2" (Node "c" "3" EmptyNode EmptyNode) EmptyNode))])

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
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables
            else if (findTable state.table tables) == Nothing then (clearState ("Vytvorená nová tabuľka: " ++ state.table), newOrEmpty state.table tables)
            else (clearState ("Tabuľka " ++ state.table ++ " bola vyprázdnená"), newOrEmpty state.table tables)
        Insert ->
            if validate ["table", "key", "value"] state == False then missingArguments "názov tabuľky, kľúč a hodnotu" state tables
            else if (findTable state.table tables) == Nothing then tableNotFound state tables
            else (clearState ("Vložená hodnota '" ++ state.value ++ "' pod kľučom '" ++ state.key ++ "' do tabuľky " ++ state.table), insert state.table state.key state.value tables)
        Show ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t -> (clearState ("Tabuľka " ++ state.table ++ ": " ++ show t), tables)
        ShowRep ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t -> (clearState ("Štruktúra tabuľky " ++ state.table ++ ": " ++ showRep t), tables)
        IsIn ->
            if validate ["table", "key"] state == False then missingArguments "názov tabuľky, kľúč" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t -> (clearState ("Kľúč '" ++ state.key ++ "' sa v tabuľke " ++ state.table ++ " " ++ (if isIn state.key t then "nachádza" else "nenachádza")), tables)
        Value ->
            if validate ["table", "key"] state == False then missingArguments "názov tabuľky, kľúč" state tables
            else let result = findTable state.table tables
                in case result of
                    Nothing -> tableNotFound state tables
                    Just t ->
                        let v = valueForKey state.key t
                        in case v of
                            Nothing -> (clearState ("Kľúč '" ++ state.key ++ "' sa v tabuľke " ++ state.table ++ " nenachádza"), tables)
                            Just val -> (clearState ("Kľúč '" ++ state.key ++ "' má v tabuľke " ++ state.table ++ " hodnotu: " ++ val), tables)





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

validate: List String -> State -> Bool
validate list state =
    let
        compare key =
            case key of
                "table" -> state.table /= ""
                "key" -> state.key /= ""
                "value" -> state.value /= ""
                _ -> False
    in case list of
        [] -> True
        key :: rest ->
            if compare key == False then False
            else validate rest state





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
        button [onClick ShowRep] [text "Zobraziť reprezentáciu"],
        button [onClick IsIn] [text "Je v"],
        button [onClick Value] [text "Hodnota"],
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
    in bstReduce toStr "" <| Tuple.second table

showRep: Table -> String
showRep (name, values) =
    let
        showTree tree =
            case tree of
                EmptyNode -> "EmptyNode"
                Node key value lc rc ->
                    "Node \"" ++ key ++ "\" \"" ++ value ++ "\" " ++
                    (if lc == EmptyNode then showTree lc else "(" ++ showTree lc ++ ")") ++ " " ++
                    (if rc == EmptyNode then showTree rc else "(" ++ showTree rc ++ ")")
    in "(\"" ++ name ++ "\", " ++ showTree values ++ ")" 

isIn: String -> Table -> Bool
isIn key (name, values) =
    bstFind key values /= Nothing

valueForKey: String -> Table -> Maybe String
valueForKey key (name, values) =
    let n = bstFind key values
    in case n of
        Nothing -> Nothing
        Just t ->
            case t of
                EmptyNode -> Nothing
                Node k v lc rc -> Just v





bstInsert: String -> String -> BST String -> BST String
bstInsert key value tree =
    case tree of
        EmptyNode -> Node key value EmptyNode EmptyNode
        Node nKey nVal nLC nRC ->
            if nKey == key then Node key value nLC nRC
            else if key < nKey then Node nKey nVal (bstInsert key value nLC) nRC
            else Node nKey nVal nLC (bstInsert key value nRC)

bstReduce: (BST String -> b -> b) -> b -> BST String -> b
bstReduce fnc acc tree =
    case tree of
        EmptyNode -> fnc EmptyNode acc
        Node key value lc rc ->
            bstReduce fnc (bstReduce fnc (fnc (Node key value lc rc) acc) lc) rc

bstFind: String -> BST String -> Maybe (BST String)
bstFind key tree =
    case tree of
        EmptyNode -> Nothing
        Node k v lc rc ->
            if key == k then Just (Node k v lc rc)
            else if key < k then bstFind key lc
            else bstFind key rc

