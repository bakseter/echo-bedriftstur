port module Page.LoggInn exposing (init, subscriptions, update, view, Model, Msg)

import Html exposing (Html, div, text, h1, h3, img, form, input, br, p, i)
import Html.Attributes exposing (class, id, src, alt, type_, name, value, style, method)
import Html.Events
import Json.Encode
import Json.Decode
import String

type Msg
    = TypedEmail String
    | SendSignInLink
    | SendSignInLinkError Json.Encode.Value

type Error
    = None
    | InvalidEmail
    | UnathorizedContinueUri
    | InvalidContinueUri
    | ArgumentError

type alias Model = 
    { email : String
    , submittedEmail : Bool
    , error : Error
    , info : String
    }
     
init : Model
init =
    { email = ""
    , submittedEmail = False
    , error = None
    , info = ""
    }

subscriptions : Model -> Sub Msg
subscriptions model =
     sendSignInLinkError SendSignInLinkError

port sendSignInLink : Json.Encode.Value -> Cmd msg
port sendSignInLinkError : (Json.Encode.Value -> msg) -> Sub msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        TypedEmail str ->
            ({ model | email = str }, Cmd.none)
        SendSignInLink ->
            ({ model | submittedEmail = True }, sendSignInLink (encode model))
        SendSignInLinkError json ->
            let error = errorFromString <| getErrorCode <| Json.Encode.encode 0 json
            in
                ({ model | error = error }, Cmd.none)

view : Model -> Html Msg
view model =
    showPage model

encode : Model -> Json.Encode.Value
encode model =
    Json.Encode.object
        [ ( "email", Json.Encode.string model.email ) ]

showPage : Model -> Html Msg
showPage model =
    if model.submittedEmail && model.error == None
    then
        div [ class "logg-inn" ]
            [ div [] []
            , div []
                [ h1 [] [ text "Registrer deg/logg inn" ]
                , p []
                    [ text ("Vi har nå sendt deg en mail på " ++ model.email ++ ".") ]
                , p []
                    [ text "Husk å sjekke søppelposten din!" ]
                , h3 [] [text (getErrorCode model.info) ]
                ]
            ]
    else
        div [ class "logg-inn" ]
            [ div [] []
            , div []
                [ h1 [] [ text "Registrer deg/logg inn" ] 
                , div [ id "login-info" ]
                    [ p [] 
                        [ text "For å registrere deg eller logge inn, vennligst oppgi en gyldig studentmail på formen:" ]
                    , p [ style "font-style" "italic" ]
                        [ text "Fornavn.Etternavn@student.uib.no" ]
                    , p []
                        [ text "Du vil få tilsendt en link til mailen du oppgir. Denne bruker du for å logge inn." ]
                    ]
                , div [ id "login-form" ]
                    [ h3 [] [ text "Email" ]
                    , input [ id "email", type_ "text", name "Email", Html.Events.onInput TypedEmail ] []
                    , isEmailCorrect model
                    , br [] []
                    , br [] []
                    , input [ id "submitBtn", type_ "submit", value "Logg inn", Html.Events.onClick SendSignInLink ] []
                    ]
                , h3 [] [text (errorMessageToUser model.error) ]
                ]
            ]

-- TODO: make this less spaghetti
isEmailCorrect : Model -> Html msg
isEmailCorrect model =
    let split = String.split "@" model.email
        domain = List.head (List.drop ((List.length split) - 1) split)
        invalid = i [class "fa fa-times", id "email-invalid" ] []
    in
        if List.length split == 1 || List.head split == Just "" || List.head split == Nothing
        then
            invalid
        else
            case domain of
                Just str ->
                    if str == "student.uib.no"
                    then
                        i [ class "fa fa-check", id "email-valid" ] []
                    else
                        invalid
                Nothing ->
                        invalid

getErrorCode : String -> String
getErrorCode json =
    case Json.Decode.decodeString (Json.Decode.at ["code"] Json.Decode.string) json of
        Ok code ->
            code
        Err _ ->
            ""

errorFromString : String -> Error
errorFromString str =
    case str of
        "auth/invalid-email" ->
            InvalidEmail
        "auth/unauthorized-continue-uri" ->
            UnathorizedContinueUri
        "auth/invalid-continue-uri" ->
            InvalidContinueUri
        "auth/argumenterror" ->
            ArgumentError
        _ ->
            None

errorMessageToUser : Error -> String
errorMessageToUser error =
    case error of
        InvalidEmail ->
            "Mailen du har skrevet inn har ikke riktig format. Prøv igjen"
        None ->
            ""
        _ ->
            "Det har skjedd en feil. Prøv igjen senere"
