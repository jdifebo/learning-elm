import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Navigation
import String
import Shared.Styles as Styles
import SimpleApp
import Cats

main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }


toUrl : ActivePage -> String
toUrl mode =
  let path =
    case mode of
      SimpleAppPage model ->
        "simple"

      CatsPage model ->
        "cats"

      NotFound str ->
        str
  in
    "#/" ++ path


fromUrl : String -> String
fromUrl url =
  (String.dropLeft 2 url)
  -- let substring =
  --   (String.dropLeft 2 url)
  -- in
  --   case substring of
  --     "simple" ->
  --       SimpleAppPage

  --     "cats" ->
  --       CatsPage
        
  --     _ ->
  --       NotFound substring



urlParser : Navigation.Parser String
urlParser =
  Navigation.makeParser (fromUrl << .hash)



-- MODEL


type alias Model = 
  { activePage : ActivePage
  }

type ActivePage 
  = SimpleAppPage SimpleApp.Model 
  | CatsPage Cats.Model
  | NotFound String

init : String -> (Model, Cmd Msg)
init mode = 
  urlUpdate mode (Model <| NotFound "")



-- UPDATE


type Msg = SimpleAppMsg SimpleApp.Msg | CatsMsg Cats.Msg

getSimpleAppModel model =
  case model.activePage of
    SimpleAppPage m ->
      m
    _ ->
      SimpleApp.Model "" (Err "")

      
getCatsModel model =
  case model.activePage of
    CatsPage m ->
      m
    _ ->
      fst <| Cats.init "cats"

update : Msg -> Model -> (Model, Cmd Msg)
update baseMsg model =
  case baseMsg of
    SimpleAppMsg msg ->
      let updateResult = 
        SimpleApp.update msg (getSimpleAppModel model)
      in
        ({model | activePage = SimpleAppPage updateResult}, Cmd.none)

    CatsMsg msg ->
      let updateResult = 
        Cats.update msg (getCatsModel model)
      in
        ({model | activePage = CatsPage <| fst updateResult}, Cmd.map (\msg -> CatsMsg msg) (snd updateResult))

    


{-| The URL is turned into a result. If the URL is valid, we just update our
model to the new count. If it is not a valid URL, we modify the URL to make
sense.
-}
-- urlUpdate : path -> Model -> (Model, Cmd Msg)
urlUpdate path model =
  case path of
    "simple" ->
      ({model | activePage = SimpleAppPage (SimpleApp.Model "" (Err ""))}, Cmd.none)

    "cats" ->
      let initResult = 
        Cats.init "cats"
      in
        ({model | activePage = CatsPage (fst initResult)}, Cmd.map (\msg -> CatsMsg msg) (snd initResult))

    _ ->
      ({model | activePage = NotFound path}, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div [Styles.styles]
    [ h1 [] [text "Simple Navigation"]
    , div [] [text 
        """Use the buttons to change the URL.  This also automatically changes which view is displayed 
        below.  Alternatively, you can type in the address bar too.  See what happens when you enter
        a url that's not /first or /second"""
      ]
    , embeddedAppView model
    ]

embeddedAppView : Model -> Html Msg
embeddedAppView model = 
  case model.activePage of
    SimpleAppPage simpleAppModel->
      App.map (\msg -> SimpleAppMsg msg) (SimpleApp.view simpleAppModel) 

    CatsPage catsModel ->
      App.map (\msg -> CatsMsg msg) (Cats.view catsModel) 

    NotFound path ->
      h3 [style [("color", "red")]] [text <| "path not found: " ++ path]