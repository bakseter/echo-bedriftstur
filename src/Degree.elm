module Degree exposing (Degree(..), Degrees(..), toString, fromString, orNullDecoder)

import Json.Decode as Decode

-- Type wrapper for the Degrees type
type Degree
    = Valid Degrees
    | None

-- Type representing all the possible degrees a student can have
type Degrees
    = DTEK
    | DSIK
    | DVIT
    | BINF
    | IMØ
    | IKT
    | KOGNI
    | INF
    | PROG
    | POST
    | MISC

-- List of valid degrees with their shorthand and long strings
degreesList : List (Degrees, (String, String))
degreesList =
    [ (DTEK, ("DTEK", "Datateknologi"))
    , (DVIT, ("DVIT", "Datavitenskap"))
    , (DSIK, ("DSIK", "Datasikkerhet"))
    , (BINF, ("BINF", "Bioinformatikk"))
    , (IMØ, ("IMØ", "Informatikk-matematikk-økonomi"))
    , (IKT, ("IKT", "Informasjons- og kommunikasjonsteknologi"))
    , (KOGNI, ("KOGNI", "Kognitiv vitenskap med spesialisering i informatikk"))
    , (INF, ("INF", "Master i informatikk"))
    , (PROG, ("PROG", "Felles master i programutvikling"))
    , (POST, ("POST", "Postbachelor"))
    , (MISC, ("MISC", "Annet studieløp"))
    ]

-- Convert degree to either shorthand or long string
toString : Bool -> Degree -> String
toString shorthand degree =
    case degree of
        Valid d ->
            case List.filter (\(x,(y,z)) -> x == d) degreesList of
                [ (deg, (short, long)) ] ->
                    if shorthand then
                        short
                    else
                        long
                _ ->
                    ""
        None ->
            ""

-- Convert either shorthand or long string to degree
fromString : Bool -> String -> Degree
fromString shorthand str =
    let filter arg = if shorthand then
                        (\(x,(y,z)) -> y == str)
                     else
                       (\(x,(y,z)) -> z == str)
    in
        case List.filter (filter str) degreesList of
            [ (deg, (short, long)) ] ->
                Valid deg
            _ ->
                None

{-
    Decodes a degree from a JSON value.
    Returns (Valid Degrees) if successful.
    Return None if not successful
-}
orNullDecoder : String -> Decode.Decoder Degree
orNullDecoder field =
    Decode.oneOf
        [ Decode.map (fromString False) (Decode.at [ field ] Decode.string)
        , Decode.at [ field ] (Decode.null None)
        , Decode.succeed None
        ]
