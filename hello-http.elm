import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Shared.Styles as Styles


main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }



-- MODEL


type alias Model =
  { results : List String
  }


init : (Model, Cmd Msg)
init =
  ( Model []
  , getLocalJson
  )



-- UPDATE


type Msg
  = RefreshJson
  | FetchSucceed (List String)
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RefreshJson ->
      (model, getLocalJson)

    FetchSucceed results ->
      ({model | results = results}, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div [Styles.styles]
    [ h1 [] [text "Simple HTTP example"]
    , p [] [text
        """HTTP introduces some extra complexity because we now have to use commands
        to communicate with the outside world.  Our update function doesn't just 
        return a new model, but instead it returns a model and a command.  This command
        can then do something and then return to our update function with a new value.
        """
      ]
    , p [] [text
        """For example, when a user presses a button, we create a command to fetch some 
        data using a HTTP get request.  We also specify what messages it should return with
        once the fetch either succeeds or fails, allowing us to modify our model after
        the fetch is performed.
        """
    ]
    , button [ onClick RefreshJson ] [ text "Refresh (doesn't actually do anything because the data doesn't change)" ]
    , div [] (List.map (\str -> p [] [text str]) model.results)
    ]


-- HTTP


getLocalJson : Cmd Msg
getLocalJson =
  let
    url =
      "resources/test.json"
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder (List String)
decodeGifUrl =
  Json.list Json.string
