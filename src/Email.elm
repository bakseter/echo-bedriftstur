module Email exposing (..)

import Json.Decode as Decode

type Email
    = Email String

toString : Email -> String
toString (Email email) =
    email

orNullDecoder field =
    Decode.oneOf
        [ Decode.map Email (Decode.at [ field ] Decode.string)
        , Decode.at [ field ] (Decode.null (Email ""))
        ] 
