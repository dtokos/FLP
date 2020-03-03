module Cv_1 exposing (..)

import Html exposing (text)

main =
    --text <| fromBoolIf (5 > 6)
    --text <| fromBoolCase (5 > 6)
    text <| fromTuple(5, "ahoj")

fromBoolIf : Bool -> String
fromBoolIf x =
    if x == True then
        "True"
    else
        "False"

fromBoolCase : Bool -> String
fromBoolCase x =
    case x of
        True -> "True"
        False -> "False"

fromTuple : (Int, String) -> String
fromTuple (a, b) =
    (String.fromInt a) ++ ", " ++ b
