import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String


main =
  beginnerProgram { model = (Model True True), view = view, update = update }

type alias Model =
  { isHidden1 : Bool
  , isHidden2 : Bool
  }
  

type Msg = 
    ToggleSection1 
  | ToggleSection2

update msg model =
  case msg of
    ToggleSection1 ->
      {model | isHidden1 = not model.isHidden1}
    ToggleSection2 ->
      {model | isHidden2 = not model.isHidden2}

view model =
  div [] [
    intro 
  , div [] (checkboxes model)
  , (div [] (section1 model))
  , (div [] (section2 model))
  ]

intro =
  div [] [ 
    h1 [] [text "Hiding Sections"]
    , p [] [text """
      Hiding sections isn't super difficult, but it does require modifying the model.  Oh well.
    """]
    , br [] []
  ]

checkboxes model = 
  [
    (checkbox ToggleSection1 model.isHidden1 "Show Section 1")
  , (checkbox ToggleSection2 model.isHidden1 "Show Section 2")
  ]
  

checkbox : msg -> Bool -> String -> Html msg
checkbox msg value name =
  label
    [ style [("padding", "20px")]
    ]
    [ input [ type' "checkbox", onClick msg ] []
    , text name
    ]

section1 model = 
  case model.isHidden1 of 
    True -> 
      []
    False ->
      [text "This is section 1"]
      
section2 model = 
  case model.isHidden2 of 
    True -> 
      []
    False ->
      [text "This is section 2"]
