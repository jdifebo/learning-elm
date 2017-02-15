module Shared.Accordion exposing (accordion)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)


accordion contentList indexToShow msg =
  let 
    sectionHTML indexToShow currentIndex (header, body) =
      let 
        bodySection =
          if currentIndex == indexToShow then
            body
          else
            text ""
      in 
        div [] [
          div [onClick (msg currentIndex)] [
            header
          ]
        , bodySection
        ]
  in
    div [] (List.indexedMap (sectionHTML indexToShow) contentList)