module Page.Om exposing (Model, Msg, init, route, subscriptions, update, view)

import Browser.Navigation
import Html exposing (Html, a, div, i, img, span, text)
import Html.Attributes exposing (alt, class, href, id, rel, src, target)
import Html.Events


route : String
route =
    "om"


type Msg
    = EliasMail
    | AndreasMail
    | TuvaMail
    | EliasLinkedIn
    | AndreasLinkedIn
    | TuvaLinkedIn


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
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EliasMail ->
            ( { model | showMailElias = True }, Cmd.none )

        AndreasMail ->
            ( { model | showMailAndreas = True }, Cmd.none )

        TuvaMail ->
            ( { model | showMailTuva = True }, Cmd.none )

        EliasLinkedIn ->
            ( model, Browser.Navigation.load "https://www.linkedin.com/in/elias-djupesland-a51462176/" )

        AndreasLinkedIn ->
            ( model, Browser.Navigation.load "https://www.linkedin.com/in/andreas-salhus-bakseter-54416316a/" )

        TuvaLinkedIn ->
            ( model, Browser.Navigation.load "https://www.linkedin.com/in/tuva-kvalsoren" )


view : Model -> Html Msg
view model =
    let
        ( eliasMail, eliasClass ) =
            getMail model EliasMail

        ( andreasMail, andreasClass ) =
            getMail model AndreasMail

        ( tuvaMail, tuvaClass ) =
            getMail model TuvaMail
    in
    div [ class "om" ]
        [ div [ id "om-content" ]
            [ div [ id "om-tekst" ]
                [ div [ class "text" ] [ text "Bedriftsturkomitéen består av tre frivillige studenter." ]
                , span [ class "text" ] [ text "Har du noen spørsmål om turen? Send oss gjerne en mail på " ]
                , a [ class "text-underline", href "mailto:kontakt@echobedriftstur.no" ]
                    [ text "kontakt@echobedriftstur.no" ]
                , span [ class "text" ] [ text "." ]
                ]
            , div [ id "elias" ] [ img [ class "portrett", src "/img/elias.png", alt "Elias", Html.Events.onClick EliasLinkedIn ] [] ]
            , div [ class "om-info", id "elias-info" ]
                [ div [ class "om-navn text-center" ] [ text "Elias Djupesland" ]
                , div [ class "text-center" ] [ text "Leder og bedriftskontakt" ]
                , div [ class "text-center", class eliasClass, Html.Events.onClick EliasMail ]
                    [ text eliasMail ]
                ]
            , div [ id "andreas" ] [ img [ class "portrett", src "/img/andreas.png", alt "Andreas", Html.Events.onClick AndreasLinkedIn ] [] ]
            , div [ class "om-info", id "andreas-info" ]
                [ div [ class "om-navn text-center" ] [ text "Andreas Salhus Bakseter" ]
                , div [ class "text-center" ] [ text "Webansvarlig" ]
                , div [ class "text-center", class andreasClass, Html.Events.onClick AndreasMail ]
                    [ text andreasMail ]
                ]
            , div [ id "tuva" ] [ img [ class "portrett", src "/img/tuva.png", alt "Tuva", Html.Events.onClick TuvaLinkedIn ] [] ]
            , div [ class "om-info", id "tuva-info" ]
                [ div [ class "om-navn text-center" ] [ text "Tuva Kvalsøren" ]
                , div [ class "text-center" ] [ text "PR-ansvarlig" ]
                , div [ class "text-center", class tuvaClass, Html.Events.onClick TuvaMail ]
                    [ text tuvaMail ]
                ]
            ]
        , div [ id "om-links" ]
            [ a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href "https://www.linkedin.com/showcase/echobedriftstur"
                , id "linkedinLink"
                ]
                [ i [ class "fa fa-linkedin" ] [] ]
            , a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href "https://github.com/bakseter/echo-bedriftstur"
                , id "githubLink"
                ]
                [ i [ class "fa fa-github" ] [] ]
            ]
        ]


getMail : Model -> Msg -> ( String, String )
getMail model msg =
    let
        hiddenMail =
            ( "hidden-mail", "Trykk for mail" )
    in
    case msg of
        EliasMail ->
            if model.showMailElias then
                ( "mail", "elias.djupesland@echo.uib.no" )

            else
                hiddenMail

        AndreasMail ->
            if model.showMailAndreas then
                ( "mail", "andreas.bakseter@echo.uib.no" )

            else
                hiddenMail

        TuvaMail ->
            if model.showMailTuva then
                ( "mail", "tuva.kvalsoren@echo.uib.no" )

            else
                hiddenMail

        _ ->
            ( "", "" )
