import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Navigation
import String
import Shared.Styles as Styles


main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }



-- URL PARSERS - check out evancz/url-parser for fancier URL parsing


toUrl : ViewMode -> String
toUrl mode =
  let path =
    case mode of
      First ->
        "first"

      Second ->
        "second"

      Other str ->
        str
  in
    "#/" ++ path


fromUrl : String -> ViewMode
fromUrl url =
  let substring =
    (String.dropLeft 2 url)
  in
    case substring of
      "first" ->
        First

      "second" ->
        Second

      "" ->
        First

      _ ->
        Other substring



urlParser : Navigation.Parser ViewMode
urlParser =
  Navigation.makeParser (fromUrl << .hash)



-- MODEL


type alias Model = 
  { mode : ViewMode
  }

type ViewMode = First | Second | Other String

init : ViewMode -> (Model, Cmd Msg)
init mode = 
  urlUpdate mode (Model First)



-- UPDATE


type Msg = NavigateToFirst | NavigateToSecond


{-| A relatively normal update function. The only notable thing here is that we
are commanding a new URL to be added to the browser history. This changes the
address bar and lets us use the browser&rsquo;s back button to go back to
previous pages.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NavigateToFirst ->
      (model, Navigation.newUrl (toUrl First))

    NavigateToSecond ->
      (model, Navigation.newUrl (toUrl Second))
    


{-| The URL is turned into a result. If the URL is valid, we just update our
model to the new count. If it is not a valid URL, we modify the URL to make
sense.
-}
-- urlUpdate : path -> Model -> (Model, Cmd Msg)
urlUpdate viewMode model =
  ({model | mode = viewMode}, Cmd.none)



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
    , button [ onClick NavigateToFirst ] [ text "navigate to /first" ]
    , button [ onClick NavigateToSecond ] [ text "navigate to /second" ]
    , activeSectionView model
    ]

activeSectionView : Model -> Html Msg
activeSectionView model = 
  let 
    color c =
      style [("color", c)]
  in    
    case model.mode of
      First ->
        h3 [color "purple"] [text "this is the view for the first mode"]

      Second -> 
        h3 [color "darkcyan"] [text "this is the view for the second mode"]

      Other path ->
        h3 [color "red"] [text <| "path not found: " ++ path]