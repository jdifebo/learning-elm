module SimpleApp exposing (..)

import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String


main =
  beginnerProgram { model = (Model "" (Err "")), view = view, update = update }

type alias Model =
  { inputField : String
  , calculatedValue : Result String Float
  }
  

type Msg = 
    InputChange String 
  | Calculate

update msg model =
  case msg of
    InputChange newValue ->
      {model | inputField = newValue}

    Calculate ->
      {model | calculatedValue = poundsToKilograms model.inputField}

poundsToKilograms : String -> Result String Float
poundsToKilograms input = 
    case String.toFloat input of
        Ok n -> Ok (n * 2.2)
        Err _ -> Err <| "Could not convert " ++ (toString input) ++ " to a valid number!"


view model =
  div [] (intro ++ (poundsToKilogramsConverter model))

intro =
  [ h1 [] [text "A simple calculator"]
  , p [] [text "It's simple to have some dynamic behavior that depends on the user's actions by creating a beginnerProgram!"]
  , p [] [text """
    This example has 2 inputs.  When the user types in the text field, our model is updated to reflect the new input value,
    but no calculation is done until the button is pressed.  There is also some validation; if the text in the input field
    isn't a number, we display an error message to the user instead of the calulated value. 
  """]
  , br [] []
  ]

poundsToKilogramsConverter model = 
  [ h3 [] [text "Pounds to Kilograms converter"]
  , input [type' "text",  placeholder "Put in a number", onInput InputChange] []
  , button [ onClick Calculate ] [ text "Calculate" ]
  , div [] [ text <| resultView model.calculatedValue]
  ]

resultView : Result String Float -> String
resultView result = 
  case result of 
    Ok value -> 
      (toString value) ++ " kg"
    Err message ->
      message
