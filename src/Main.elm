module Main exposing (main)

import Browser
import CodeSample
import Html



-- MODEL / INIT


type alias Model =
    { title : String
    }


type alias Msg =
    Never


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { title = "DataUtil Demo"
            }
    in
    ( model, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        f1 =
            Debug.log "factorial" CodeSample.factorial

        f2 =
            Debug.log "factorial2" CodeSample.factorial2
    in
    { title = model.title
    , body = [ Html.text "see debugger" ]
    }
