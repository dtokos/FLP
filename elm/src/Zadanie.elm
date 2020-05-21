module Zadanie exposing (..)

-- Dobroslav Tokoš
-- K projektu prikladám aj testy, ktoré sú v súbore "BSTTests.elm". Tie sú písané pomocou elm-test knižnice (https://www.npmjs.com/package/elm-test).

import Browser
import List exposing (map, filter)
import Html exposing (Html, h3, input, div, br, strong, text, button)
import Html.Attributes exposing (type_, placeholder, value)
import Html.Events exposing (..)

main =
    Browser.sandbox{init = init, update = update, view = view}

-- Typové definície
type alias Model = (State, Tables) -- Reprezentuje stav celej aplikácie
type alias Tables = List Table -- Reprezentuje tabuľky
type alias Table = (String, BST String) -- Reprezentuje jednu tabuľku
type BST a = EmptyNode | Node String String (BST a)(BST a) -- Reprezentuje binárny strom
type alias State = { -- Reprezentuje stav inputov
        table: String,
        table2: String,
        key: String,
        value: String,
        output: String
    }
type Message = -- Reprezentuje typy správ, ktoré môžme dostať z UI
    SetTable String |
    SetTable2 String |
    SetKey String |
    SetValue String |
    NewOrEmpty |
    Insert |
    Show |
    ShowRep |
    IsIn |
    Value |
    Remove |
    Card |
    Dom |
    Equal

init: Model -- Inicializuje stav aplikácie
init = (clearState "", [("foo", Node "50" "50" (Node "40" "40" EmptyNode EmptyNode) (Node "60" "60" (Node "55" "55" (Node "54" "54" EmptyNode EmptyNode) (Node "57" "57" (Node "56" "56" EmptyNode EmptyNode) (Node "58" "58" EmptyNode EmptyNode))) EmptyNode))])

update: Message -> Model -> Model -- Volá sa po neakej interakcii s UI a vracá nový stav
update message (state, tables) =
    case message of
        -- Mení stavy inputov
        SetTable t ->
            ({state | table = t, output = ""}, tables)
        SetTable2 t ->
            ({state | table2 = t, output = ""}, tables)
        SetKey k ->
            ({state | key = k, output = ""}, tables)
        SetValue v ->
            ({state | value = v, output = ""}, tables)

        -- Volané pri kliknutí na tlačidlo "Pridať/vyprázdniť"
        NewOrEmpty ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables -- Ošetruje prázdne vstupy
            else if (findTable state.table tables) == Nothing then (clearState ("Vytvorená nová tabuľka: " ++ state.table), newOrEmpty state.table tables) -- Ak tabuľka ešte neexistuje
            else (clearState ("Tabuľka " ++ state.table ++ " bola vyprázdnená"), newOrEmpty state.table tables) -- Ak tabuľka existuje
        Insert ->
            if validate ["table", "key", "value"] state == False then missingArguments "názov tabuľky, kľúč a hodnotu" state tables -- Ošetruje prázdne vstupy
            else if (findTable state.table tables) == Nothing then tableNotFound state tables -- Ak tabuľka neexistuje
            else (clearState ("Vložená hodnota '" ++ state.value ++ "' pod kľučom '" ++ state.key ++ "' do tabuľky " ++ state.table), insert state.table state.key state.value tables) -- Ak tabuľka existuje
        Show ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> (clearState ("Tabuľka " ++ state.table ++ ": " ++ show t), tables) -- Ak tabuľka existuje
        ShowRep ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> (clearState ("Štruktúra tabuľky " ++ state.table ++ ": " ++ showRep t), tables) -- Ak tabuľka existuje
        IsIn ->
            if validate ["table", "key"] state == False then missingArguments "názov tabuľky, kľúč" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables  -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> (clearState ("Kľúč '" ++ state.key ++ "' sa v tabuľke " ++ state.table ++ " " ++ (if isIn state.key t then "nachádza" else "nenachádza")), tables) -- Ak tabuľka existuje
        Value ->
            if validate ["table", "key"] state == False then missingArguments "názov tabuľky, kľúč" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> -- Ak tabuľka existuje
                        let v = valueForKey state.key t -- Nájdem hodnotu pre požadovaný kľúč
                        in case v of
                            Nothing -> (clearState ("Kľúč '" ++ state.key ++ "' sa v tabuľke " ++ state.table ++ " nenachádza"), tables) -- Ak kľúč v tabuľke neexistuje
                            Just val -> (clearState ("Kľúč '" ++ state.key ++ "' má v tabuľke " ++ state.table ++ " hodnotu: " ++ val), tables) -- Ak kľúč v tabuľke existuje
        Remove ->
            if validate ["table", "key"] state == False then missingArguments "názov tabuľky, kľúč" state tables -- Ošetruje prázdne vstupy
            else if (findTable state.table tables) == Nothing then tableNotFound state tables -- Ak tabuľka neexistuje
            else (clearState ("Kľúč '" ++ state.key ++ "' bol z tabuľky " ++ state.table ++ " vymazaný"), remove state.table state.key tables) -- Ak tabuľka existuje
        Card ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> (clearState ("Počet prvkov tabuľky " ++ state.table ++ " je: " ++ (String.fromInt <| card t)), tables) -- Ak tabuľka neexistuje
        Dom ->
            if validate ["table"] state == False then missingArguments "názov tabuľky" state tables -- Ošetruje prázdne vstupy
            else let result = findTable state.table tables -- Nájdem požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak tabuľka neexistuje
                    Just t -> (clearState ("Zoznam kľúčov tabuľky " ++ state.table ++ " je: " ++ (dom t)), tables)
        Equal ->
            if validate ["table", "table2"] state == False then missingArguments "názov prvej aj druhej tabuľky" state tables -- Ošetruje prázdne vstupy
            else let
                    result = findTable state.table tables -- Nájdem prvú požadovanú tabuľku
                    result2 = findTable state.table2 tables -- Nájdem druhú požadovanú tabuľku
                in case result of
                    Nothing -> tableNotFound state tables -- Ak prvá tabuľka neexistuje
                    Just t -> -- Ak prvá tabuľka existuje
                        case result2 of
                            Nothing -> tableNotFound state tables -- Ak druhá tabuľka neexistuje
                            Just t2 -> (clearState ("Tabuľky " ++ state.table ++ " a " ++ state.table2 ++ " sú " ++ (if (equal t t2) then "rovnaké" else "rozdielne")), tables) -- Ak druhá tabuľka exsituje




-- Vyčistí stav a ponechá tabuľky
clearState: String -> State
clearState out =
    State "" "" "" "" out

-- Ponechá celý stav
keepState: State -> String -> State
keepState state out =
    State state.table state.table2 state.key state.value out

-- Vráti rovnaký stav a nastaví správu na chýbajúce polia
missingArguments: String -> State -> Tables -> Model
missingArguments missing state tables =
    (keepState state ("Zadajte " ++ missing), tables)

-- Vráti rovnaký stav a nastaví správu na tabuľka sa nenašla
tableNotFound: State -> Tables -> Model
tableNotFound state tables =
    (keepState state ("Tabuľka " ++ state.table ++ " neexistuje"), tables)

-- Overí či vstup má vyplnené všetky požadované atribúty
validate: List String -> State -> Bool
validate list state =
    let
        compare key =
            case key of
                "table" -> state.table /= ""
                "table2" -> state.table2 /= ""
                "key" -> state.key /= ""
                "value" -> state.value /= ""
                _ -> False
    in case list of
        [] -> True
        key :: rest ->
            if compare key == False then False
            else validate rest state




-- Vykreslí stránku z aktuálneho stavu
view: Model -> Html Message
view (state, tables) =
    div [] [
        h3 [] [text "Zadanie"],
        htmlInput "Názov tabulky" state.table SetTable,
        br [] [],
        htmlInput "Názov druhej tabulky" state.table2 SetTable2,
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
        button [onClick Remove] [text "Vymazať"],
        button [onClick Card] [text "Počet prvkov"],
        button [onClick Dom] [text "Zoznam kľúčov"],
        button [onClick Equal] [text "Ekvivalentnosť"],
        br [] [],
        br [] [],
        div [] [text <| "Dostupné tabuľky: " ++ viewTables tables],
        br [] [],
        br [] [],
        strong [] [text state.output]
    ]

-- Pomocná funkcia, ktorá vytvorí textový input
htmlInput: String -> String -> (String -> msg) -> Html msg
htmlInput ph val msg =
    input [type_ "text", placeholder ph, value val, onInput msg] []

-- Naformátuje tabuľky do stringu
viewTables: Tables -> String
viewTables tables =
    listToString Tuple.first tables

-- Naformátuje zoznam do strinu
listToString: (a -> String) -> List a -> String
listToString fnc list =
    "[" ++ (String.join ", " (map fnc list)) ++ "]"




-- Vytvorí/vyprázni tabuľku
newOrEmpty: String -> Tables -> Tables
newOrEmpty newName tables =
    (newName, EmptyNode) :: filter (\(name, _) -> name /= newName) tables -- Pomocou filtra vymažem starú tabuľku a pridám tam novú práznu

-- Vloží hodnotu pod kľúčom do tabuľky
insert: String -> String -> String -> Tables -> Tables
insert table key value tables =
    map (\(name, tree) -> if name == table then (name, (bstInsert key value tree)) else (name, tree)) tables -- Pomocou map vloží hodnotu pod kľúčom do tabuľky. Ak sa názov tabuľky zhoduje tak ju namapujem. Inak vráti identickú tabuľku.

-- Nájde tabuľku podľa názvu
findTable: String -> Tables -> Maybe Table
findTable table tables =
    case tables of
        [] -> Nothing
        (name, tree) :: rest ->
            if name == table then Just (name, tree)
            else findTable table rest

-- Naformátuje obsah tabuľky do stringu vo formáte [Kľúč:hodnota, ...]
show: Table -> String
show (_, tree) =
    let
        toStr node acc =
            case node of
                EmptyNode -> acc
                Node k v lc rc ->
                    (k ++ ":" ++ v) :: acc
    in listToString identity (bstReduce toStr [] tree)

-- Naformátuje tabuľku do stringu vo formáte v akom je reprezentovaná. Výstupný formát je identický ako keby sme pri manuálnej definícii tabuľky: (názov tabuľky, strom). Cez strom robím preorder traversal a formátujem ho do stringu vo formáte: Node kľúč hodnota lavéDieťa pravéDieťa.
showRep: Table -> String
showRep (name, tree) =
    let
        showTree t =
            case t of
                EmptyNode -> "EmptyNode"
                Node key value lc rc ->
                    "Node \"" ++ key ++ "\" \"" ++ value ++ "\" " ++
                    (if lc == EmptyNode then showTree lc else "(" ++ showTree lc ++ ")") ++ " " ++
                    (if rc == EmptyNode then showTree rc else "(" ++ showTree rc ++ ")")
    in "(\"" ++ name ++ "\", " ++ showTree tree ++ ")" 

-- Skontroluje či kľúč sa nachádza v tabuľke.
isIn: String -> Table -> Bool
isIn key (_, tree) =
    bstFind key tree /= Nothing -- Jednoduchým binárnym vyhľadávaním zistím či sa kľúč nachádza vo strome

-- Nájde hodnotu pre kľúč v tabuľke
valueForKey: String -> Table -> Maybe String
valueForKey key (_, tree) =
    let n = bstFind key tree -- Binárnym vyhľadávaním nájdem hodnotu pre kľúč
    in case n of
        Nothing -> Nothing -- Ak sa nenašiel
        Just t ->
            case t of
                EmptyNode -> Nothing
                Node k v lc rc -> Just v -- Ak sa našiel

-- Vymaže node podľa kľúča zo stromu v tabuľke
remove: String -> String -> Tables -> Tables
remove table key tables =
    map (\(name, tree) -> if name == table then (name, (bstRemove key tree)) else (name, tree)) tables -- Pomocou map vymaže kľúč zo stromu. Ak sa názov tabuľky nezhoduje tak jednoducho vráti identickú tabuľku. Inak pomocou binárneho vymazávania vráti novú tabuľku.

-- Spočíta počet prvkov tabuľky
card: Table -> Int
card (_, tree) =
    let
        fnc node acc =
            case node of
                EmptyNode -> acc -- Ak je to prázdny node tak +0
                Node _ _ _ _ -> acc + 1 -- Inak + 1
    in bstReduce fnc 0 tree -- Redukujem strom na číslo

-- Vráti zoznam kľúčov tabuľky naformátovaný do stringu vo formáte: [kľúč, ...]
dom: Table -> String
dom (_, tree) =
    let
        toStr node acc =
            case node of
                EmptyNode -> acc -- Ak je to prázdny node tak do zoznamu nepridávam
                Node k v lc rc -> -- Inak pridám kľúč do zoznamu
                    k :: acc
    in listToString identity (bstReduce toStr [] tree) -- Redukuje strom do zoznamu a následne ho naformátuje

-- Porovná dve tabuľky
equal: Table -> Table -> Bool
equal t1 t2 =
    (show t1) == (show t2) -- Show vracia string vo formáte: [kľúč:hodnota, ...]. Prvky sú pridávané do zoznamu inorder traversalom a tým pádom sú v poradí. Následne mi stačí porovnač stringy.




-- Vloží hodnotu do binárneho stromu. Keďže sú kľúče stringy tak si treba uvedomiť že: "9" > "53" == True
bstInsert: String -> String -> BST String -> BST String
bstInsert key value tree =
    case tree of
        EmptyNode -> Node key value EmptyNode EmptyNode -- Ak je strom prázdny tak sa vytvorý nový node
        Node nKey nVal nLC nRC ->
            if nKey == key then Node key value nLC nRC -- Ak sa už našiel existujúci node tak sa jednoducho zmení hodnota
            else if key < nKey then Node nKey nVal (bstInsert key value nLC) nRC -- Ak je nový kľúč menší tak sa vloží vľavo
            else Node nKey nVal nLC (bstInsert key value nRC) -- Inak sa vloží vpravo

-- Redukuje strom do požadovaného akumulátora. Strom sa redukuje pomocou inorder traversalu.
bstReduce: (BST String -> b -> b) -> b -> BST String -> b
bstReduce fnc acc tree =
    case tree of
        EmptyNode -> fnc EmptyNode acc
        Node key value lc rc ->
            bstReduce fnc (fnc (Node key value lc rc) (bstReduce fnc acc lc)) rc

-- Nájde binárnym vyhľadávaním v strome node pre požadovaný kľúč.
bstFind: String -> BST String -> Maybe (BST String)
bstFind key tree =
    case tree of
        EmptyNode -> Nothing -- Ak sa dostaneme na koniec stromu tak sa požadovaný node nenašiel
        Node k v lc rc ->
            if key == k then Just (Node k v lc rc) -- Ak sa našiel požadovaný node tak ho vráti
            else if key < k then bstFind key lc -- Ak je požadovaný kľúč menší tak ho hľadaj v ľavom podstrome
            else bstFind key rc -- Inak ho hľadaj v pravom podstrome

-- Vymaže node podľa kľúča zo stromu
bstRemove: String -> BST String -> BST String
bstRemove key tree =
    let
        findMin node = -- Pomocná funkcia na nájdenie minima v ľavom podstrome
            case node of
                EmptyNode -> EmptyNode -- Nikdy nenastane
                Node k v lc rc ->
                    if lc == EmptyNode then (Node k v lc rc) -- Ak nemá ľavý podstrom tak sme našli minimum.
                    else findMin lc -- Inak hľadám ďalej v ľavom podstrome
    in case tree of
        EmptyNode -> EmptyNode -- Ak sme na konci tak koniec
        Node k v lc rc ->
            if key < k then Node k v (bstRemove key lc) rc -- Ak je požadovaný kľúč menší tak ho odstráň z ľavého podstromu
            else if key > k then Node k v lc (bstRemove key rc) -- Ak je požadovaný kľúč väčší tak ho odstráň z pravého podstromu
            else -- Kľúč je rovnaký
                case lc of -- Tu riešim či požadovaný prvok nemal podstromy alebo mal iba jeden podstrom alebo mal oba podstromy
                    EmptyNode ->
                        case rc of
                            EmptyNode -> EmptyNode -- Ak nemal ani ľavý ani pravý podstrom tak výsledkom je prázdny strom
                            Node rk rv rlc rrc -> Node rk rv rlc rrc -- Ak mal iba pravý podstrom tak výsledkom je pravý podstrom
                    Node lk lv llc lrc ->
                        case rc of
                            EmptyNode -> Node lk lv llc lrc -- Ak mal iba ľavý podstrom tak výsledkom je ľavý podstrom
                            Node rk rv rlc rrc -> -- Ak mal oba podstromy tak je potrebné vrátiť minimumm z pravého podstromu
                                let min = findMin (Node rk rv rlc rrc) -- Nájde minimum v pravom podstrome
                                in case min of
                                    EmptyNode -> EmptyNode -- Nikdy nenastane
                                    Node mk mv mlc mrc -> Node mk mv lc <| bstRemove mk rc -- Vráti minimum z pravého podstromu s tým že to minimum musíme z pravého podstromu vymazať
