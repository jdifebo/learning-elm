import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Shared.Styles as Styles
import Cats as Cats

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
  , catsModel : Cats.Model
  }


init : (Model, Cmd Msg)
init =
  let 
    catsInit =
      Cats.init "cats"
  in
    ( Model [] (fst catsInit) 
    , Cmd.batch [getLocalJson, Cmd.map (\msg -> CatsMsg msg) (snd catsInit)]
    )



-- UPDATE


type Msg
  = RefreshJson
  | FetchSucceed (List String)
  | FetchFail Http.Error
  | CatsMsg Cats.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RefreshJson ->
      (model, getLocalJson)

    FetchSucceed results ->
      ({model | results = results}, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    CatsMsg catsMsg ->
      let updateResult = 
        Cats.update catsMsg model.catsModel
      in
        ({model | catsModel = fst updateResult}, Cmd.map (\msg -> CatsMsg msg) (snd updateResult))



-- VIEW


view : Model -> Html Msg
view model =
  div [Styles.styles]
    [ h1 [] [text "Embedding a program inside of another program"]
    , p [] [text
        """Embedding a program is a little bit tricky, but not too terrible once you get the hang of it.
        Basically, we can go into a functioning stand-alone program and use that as a piece of a larger
        program while still allowing it to work in isolation.  To do this, the following steps must be done.
        """
      ]
    , ol [] [
        li [] [text "Export everything from the app that is to be embedded, so that we can access its Model, view, update and Msg"]
      , li [] [text "Add a field to the base app's model to contain the embedded app's model"]
      , li [] [text "Add a type to the base app's Msg type parameterized on the embedded app's message type"]
      , li [] [
          text "Add a case branch in the base app's update function to deal with the new Msg type"
        , ul [] [
            li [] [text "Use the embedded message to call the embedded app's update function"]
          , li [] [text "Take the result and update the base app's embedded model accordingly"]
          , li [] [text "Use Cmd.map to map the command into a command that the base app understands"]
          , li [] [text "Return the pair of the new model and the mapped command"]
          ]
        ]
      , li [] [text 
          """Display the view of the embedded app somewhere in the view of the base app.  You will need to 
          use Html.App.map to convert any messages that that view sends into messages that the base app understands"""
          ]
      , li [] [text "Finally, modify init to also correctly initialize the embedded app, using Cmd.batch to send multiple commands if necessary"]
    ]
    , p [] [text
        """As you can see, it's nontrivial to embed a program into another program.  Fortunately, it's also relatively 
        straightforward once you understand the necessary steps.  Also, the above example didn't deal with subscriptions,
        so that's left as an exercise for the reader (lol!).
        """
      ]
    , button [ onClick RefreshJson ] [ text "Refresh (doesn't actually do anything because the data doesn't change)" ]
    , div [] (List.map (\str -> p [] [text str]) model.results)
    , catsSection (model.catsModel)
    ]

catsSection : Cats.Model -> Html Msg
catsSection model =
  let 
    embeddedView =
      App.map (\msg -> CatsMsg msg) (Cats.view model) 
  in
    div [style [("border-style", "solid")]] [
      embeddedView
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
