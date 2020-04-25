module Error exposing (Error(..), ErrorCode(..), fromJson, toString, encode)

import Json.Encode as Encode
import Json.Decode as Decode
import Dict exposing (Dict)

type Error
    = Error ErrorCode
    | NoError

type ErrorCode
    = ErrorCode String

toString : Error -> String
toString error =
    case error of
        Error (ErrorCode str) ->
            str
        NoError ->
            ""

encode : String -> Encode.Value
encode str =
    Encode.string str

fromJson : Encode.Value -> Error
fromJson json =
    let jsonStr = Encode.encode 0 json
        maybeCode = Decode.decodeString Decode.string jsonStr
    in
        case maybeCode of
            Ok code ->
                case Dict.get code errorMsgList of
                    Just str ->
                        Error (ErrorCode str)
                    Nothing ->
                        NoError
            Err err ->
                NoError

errorMsgList : Dict String String
errorMsgList =
    let stdMsg = "Det har skjedd en feil. Vennligst prøv igjen "
    in
        Dict.fromList
            [ ("auth/app-deleted", stdMsg ++ "(feilkode 1).")
            , ("auth/app-not-authorized", stdMsg ++ "(feilkode 2).")
            , ("auth/argument-error", stdMsg ++ "(feilkode 3).")
            , ("auth/invalid-api-key", stdMsg ++ "(feilkode 4).")
            , ("auth/invalid-user-token", "Du er ikke logget inn. Vennligst logg inn og prøv på nytt (feilkode 5).")
            , ("auth/invalid-tenant-id", stdMsg ++ "(feilkode 6).")
            , ("auth/network-request-failed", "Det har skjedd en nettverksfeil. Vennligst sjekk at du er koblet til internett og prøv igjen (feilkode 7).")
            , ("auth/operation-not-allowed", stdMsg ++ "(feilkode 8).")
            , ("auth/requires-recent-login", stdMsg ++ "(feilkode 9).")
            , ("auth/too-many-requests", "Du har prøvd å logge inn for mange ganger på kort tid. Vennligst vent noen minutter og prøv igjen (feilkode 10).")
            , ("auth/unauthorized-domain", stdMsg ++ "(feilkode 11).")
            , ("auth/user-disabled", "Brukeren din har blitt deaktivert. Vennligst kontakt med på kontakt@echobedriftstur.no for mer informasjon (feilkode 12).")
            , ("auth/user-token-expired", "Du har blitt logget ut. Vennligst logg inn og prøv på nytt (feilkode 13).")
            , ("auth/web-storage-unsupported", "Du har deaktivert Web Storage. Vennligst aktiver det og prøv på nytt (feilkode 14).")
            , ("auth/invalid-email", "Mailen du har skrevet inn er ikke gyldig. Skriv inn en gyldig studentmail og prøv på nytt (feilkode 15).")
            , ("auth/expired-action-code", "Innlogginslinken er ikke gyldig lenger. Prøv å logg inn på nytt (feilkode 16).")
            , ("auth/invalid-persistence-type", stdMsg ++ "(feilkode 17).")
            , ("auth/unsupported-persistence-type", stdMsg ++ "(feilkode 18).")
            , ("auth/missing-continue-uri", stdMsg ++ "(feilkode 19).")
            , ("auth/invalid-continue-uri", stdMsg ++ "(feilkode 20).")
            , ("auth/unauthorized-continue-uri", stdMsg ++ "(feilkode 21).")
            , ("cancelled", stdMsg ++ "(feilkode 22).")
            , ("unknown", stdMsg ++ "(feilkode 23).")
            , ("invalid-argument", "Det du har skrevet inn er ikke gyldig (feilkode 24).")
            , ("deadline-exceeded", stdMsg ++ "(feilkode 25).")
            , ("not-found", stdMsg ++ "(feilkode 26).")
            , ("already-exists", stdMsg ++ "(feilkode 27).")
            , ("permission-denied", "Du har ikke tilstrekkelig tilgang til å gjøre dette (feilkode 28).")
            , ("resource-exhausted", stdMsg ++ "(feilkode 29).")
            , ("failed-precondition", stdMsg ++ "(feilkode 30).")
            , ("aborted", stdMsg ++ "(feilkode 31).")
            , ("out-of-range", stdMsg ++ "(feilkode 32).")
            , ("unimplemented", stdMsg ++ "(feilkode 33).")
            , ("internal", "Det har skjedd en feil. Vennligst kontakt oss på kontakt@echobedriftstur.no (feilkode 34).")
            , ("unavailable", "Tjenesten er ikke tilgjengelig akkurat nå. Vennligst prøv igjen senere (feilkode 35).")
            , ("data-loss", stdMsg ++ "(feilkode 36).")
            , ("unauthenticated", "Du har ikke tilgang til å utføre denne handlingen (feilkode 37).")
            , ("json-parse-error", "Det har skjedd en feil. Vennligst kontakt oss på kontakt@echobedriftstur.no (feilkode 38).")
            , ("not-signed-in", "Du er ikke logget inn. Vennligst logg inn og prøv på nytt (feilkode 39).")
            ]
