module Page.Bedrifter exposing (Model, Msg, init, route, subscriptions, title, update, view)

import Assets exposing (Assets)
import Browser.Dom
import Element exposing (Element, el, text)
import Session exposing (Session)
import Task
import Time


type Msg
    = NoOp


type alias Model =
    { session : Session
    , assets : List Assets
    , viewport : Browser.Dom.Viewport
    , mnemonicSlidIn : Bool
    , computasSlidIn : Bool
    , ciscoSlidIn : Bool
    , knowitSlidIn : Bool
    , dnbSlidIn : Bool
    , bekkSlidIn : Bool
    }


init : Session -> List Assets -> ( Model, Cmd Msg )
init session assets =
    ( { session = session
      , assets = assets
      , viewport = maybeViewport
      , mnemonicSlidIn = False
      , computasSlidIn = False
      , ciscoSlidIn = False
      , knowitSlidIn = False
      , dnbSlidIn = False
      , bekkSlidIn = False
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Element Msg
view model =
    el [] <| text "Bedrifter"


maybeViewport : Browser.Dom.Viewport
maybeViewport =
    { scene =
        { width = 0
        , height = 0
        }
    , viewport =
        { x = 0
        , y = 0
        , width = 0
        , height = 0
        }
    }


percentageOfScreenScrolled : Model -> Float
percentageOfScreenScrolled model =
    let
        yPos =
            model.viewport.viewport.y

        screenHeight =
            model.viewport.scene.height

        viewportHeight =
            model.viewport.viewport.height
    in
    (yPos + (viewportHeight / 2)) / screenHeight


allAreSlidIn : Model -> Bool
allAreSlidIn model =
    model.mnemonicSlidIn
        && model.computasSlidIn
        && model.ciscoSlidIn
        && model.knowitSlidIn
        && model.dnbSlidIn
        && model.bekkSlidIn


route : String
route =
    "bedrifter"


title : String
title =
    "Bedrifter"
