import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String
import Shared.Styles as Styles


main =
  beginnerProgram { model = (Model 0), view = view, update = update }

type alias Model =
  { section : Int
  }
  
type Msg = 
  ShowSection Int

update msg model =
  case msg of
    ShowSection section ->
      {model | section = section}

view model =
  div [Styles.styles] [
    intro 
  , sections model.section
  ]

intro =
  div [] [ 
    h1 [] [text "Making an Accordian"]
    , p [] [text """
      I want to show a bunch of headers with some additional content underneath, but only show one section's conent at a time..
      To do this, I only need to keep track of a single value in my model, the index current section to show.  I am not
      currently able to collapse all, but if I wanted to, I could change the model to use a Maybe Int instead of an Int.
      Also, I'm not able to have all sections expanded at the same time.  That might work with a new union type for
      All, None, or Section Int.
    """]
    , br [] []
  ]

type alias SectionData =
  { title : String 
  , body : String
  }


sections indexToShow =
  div [] (List.indexedMap (section indexToShow) data)


section indexToShow currentIndex d = 
  let 
    styles = 
      style [
        ("border-style", "solid")
      ]
    body =
      if currentIndex == indexToShow then
        p [style [("margin", "6px")]] [text d.body]
      else
        text ""
  in 
    div [styles] [
      div [
        style [
          ("background-color", "lightgray")
        , ("height", "40px")
        , ("text-align", "center")
        , ("font-size", "30px")
        ]
      , onClick (ShowSection currentIndex)
      ] [ 
        text d.title
      ]
    , body
    ]
      

data : List SectionData
data = 
  [ SectionData "Chameleon" 
    """Chameleons or chamaeleons (family Chamaeleonidae) are a distinctive 
    and highly specialized clade of Old World lizards with 202 species 
    described as of June 2015.[1] These species come in a range of colors, 
    and many species have the ability to change colors. Chameleons are 
    distinguished by their zygodactylous feet; their very long, highly 
    modified, rapidly extrudable tongues; their swaying gait;[2] and crests 
    or horns on their brow and snout."""

  , SectionData "Parrot" 
    """Parrots, also known as psittacines are birds of the 
    roughly 393 species in 92 genera that make up the order Psittaciformes, 
    found in most tropical and subtropical regions. The order is subdivided 
    into three superfamilies: the Psittacoidea ("true" parrots), the 
    Cacatuoidea (cockatoos), and the Strigopoidea (New Zealand parrots). 
    Parrots have a generally pantropical distribution with several species 
    inhabiting temperate regions in the Southern Hemisphere, as well. The 
    greatest diversity of parrots is in South America and Australasia."""

  , SectionData "Zebra" 
    """Zebras are several species of African equids (horse family) united by 
    their distinctive black and white striped coats. Their stripes come in 
    different patterns, unique to each individual. They are generally social 
    animals that live in small harems to large herds. Unlike their closest 
    relatives the horses and donkeys, zebras have never been truly domesticated."""
  ]
