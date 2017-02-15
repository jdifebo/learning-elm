module Shared.Styles exposing (styles)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)


styles = 
  style 
    [ ("margin", "0 auto")
    , ("max-width", "30em")
    , ("line-height", "1.5")
    , ("color", "#222")
    ]