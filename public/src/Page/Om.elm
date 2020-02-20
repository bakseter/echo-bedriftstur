module Page.Om exposing (init, subscriptions, update, view, Model, Msg)

import Html exposing (Html, div, text, img, i, a)
import Html.Attributes exposing (class, id, src, alt, href, target, rel)
import Html.Events

type Msg
    = EliasMail
    | AndreasMail
    | TuvaMail

type alias Model = 
    { showMailElias : Bool
    , showMailAndreas : Bool
    , showMailTuva : Bool
    }

init : Model
init =
    { showMailElias = False
    , showMailAndreas = False
    , showMailTuva = False
    }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        EliasMail ->
            ({ model | showMailElias = True }, Cmd.none)
        AndreasMail ->
            ({ model | showMailAndreas = True }, Cmd.none)
        TuvaMail ->
            ({ model | showMailTuva = True }, Cmd.none)

view : Model -> Html Msg
view model =
    div [ class "om" ]
        [ div [ id "om-content" ]
            [ div [ id "om-tekst" ] 
                [ div [ class "text" ] [ text "Bedriftsturkomitéen består av tre frivillige studenter." ] ]
            , div [ id "elias" ] [ img [ class "portrett", src "/img/elias.png", alt "Elias" ] [] ]
            , div [ class "om-info", id "elias-info" ]
                [ div [ class "navn" ] [ text "Elias Djupesland" ]
                , div [ class "tittel" ] [ text "Bachelor, datateknologi" ]
                , div [ class (Tuple.first (getMail model EliasMail)), Html.Events.onClick EliasMail ] [ text (Tuple.second (getMail model EliasMail)) ]
                ]
            , div [ id "andreas" ] [ img [ class "portrett", src "/img/andreas.png", alt "Andreas" ] [] ]
            , div [ class "om-info", id "andreas-info" ] 
                [ div [ class "navn" ] [ text "Andreas Salhus Bakseter" ]
                , div [ class "tittel" ] [ text "Bachelor, datateknologi" ]
                , div [ class (Tuple.first (getMail model AndreasMail)), Html.Events.onClick AndreasMail ] [ text (Tuple.second (getMail model AndreasMail)) ]
                ]
            , div [ id "tuva" ] [ img [ class "portrett", src "/img/tuva.png", alt "Tuva" ] [] ]
            , div [ class "om-info", id "tuva-info" ] 
                [ div [ class "navn" ] [ text "Tuva Kvalsøren" ]
                , div [ class "tittel" ] [ text "Bachelor, IMØ" ]
                , div [ class (Tuple.first (getMail model TuvaMail)), Html.Events.onClick TuvaMail ] [ text (Tuple.second (getMail model TuvaMail)) ]
                ]
            ]
        , div [ id "om-links" ]
            [ a [ target "_blank"
                , rel "noopener noreferrer"
                , href "https://www.linkedin.com/showcase/echobedriftstur"
                , id "linkedinLink" 
                ] [ i [ class "fa fa-linkedin" ] [] ]
            , a [ target "_blank", rel "noopener noreferrer"
                 , href "https://github.com/bakseter/echo-bedriftstur"
                 , id "githubLink" 
                 ] [ i [ class "fa fa-github" ] [] ]
            ]
        ]

getMail : Model -> Msg -> (String, String)
getMail model msg =
    let hiddenMail = ("hidden-mail", "Trykk for mail")
    in
        case msg of
            EliasMail ->
                if model.showMailElias then
                    ("mail", "elias.djupesland@echo.uib.no")
                else
                    hiddenMail
            AndreasMail ->
                if model.showMailAndreas then
                    ("mail", "andreas.bakseter@echo.uib.no")
                else
                    hiddenMail
            TuvaMail ->
                if model.showMailTuva then
                    ("mail", "tuva.kvalsoren@echo.uib.no")
                else
                    hiddenMail
