import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String
import Shared.Styles as Styles
import Shared.Accordion as Accordion

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
  , div [style [("border-style", "solid")]] [Accordion.accordion (dataToHtml data) model.section ShowSection]
  ]

intro =
  div [] [ 
    h1 [] [text "Making an Accordian"]
    , p [] [text """
      This accordian is functionally identical to the one on the last page.  The difference is that I refactored
      all of the accordian logic to be independent of what is displayed inside of it.  So the accordian function
      takes three parameters, a list of HTML pairs (for header and body), an Int for which section to display, 
      and a Msg of type Int to send to the update function when a header is clicked.
    """]
    , br [] []
  ]

type alias SectionData =
  { title : String 
  , body : String
  }


dataToHtml data =
  let
    headerToHtml header = 
      div [
        style [
          ("background-color", "lightgray")
        , ("height", "40px")
        , ("text-align", "center")
        , ("font-size", "30px")
        ]
      ] [ 
        text header
      ]
    bodyToHtml body =
      p [style [("margin", "6px")]] [text body]
  in
    List.map (\d -> (headerToHtml <| fst d, bodyToHtml <| snd d)) data



data : List (String, String)
data = 
  [ (
      "Chameleon"
    , """Chameleons or chamaeleons (family Chamaeleonidae) are a distinctive 
      and highly specialized clade of Old World lizards with 202 species 
      described as of June 2015.[1] These species come in a range of colors, 
      and many species have the ability to change colors. Chameleons are 
      distinguished by their zygodactylous feet; their very long, highly 
      modified, rapidly extrudable tongues; their swaying gait;[2] and crests 
      or horns on their brow and snout."""
    )
  , (
      "Parrot" 
    , """Parrots, also known as psittacines are birds of the 
      roughly 393 species in 92 genera that make up the order Psittaciformes, 
      found in most tropical and subtropical regions. The order is subdivided 
      into three superfamilies: the Psittacoidea ("true" parrots), the 
      Cacatuoidea (cockatoos), and the Strigopoidea (New Zealand parrots). 
      Parrots have a generally pantropical distribution with several species 
      inhabiting temperate regions in the Southern Hemisphere, as well. The 
      greatest diversity of parrots is in South America and Australasia."""
    )

  , (
      "Zebra" 
    , """Zebras are several species of African equids (horse family) united by 
      their distinctive black and white striped coats. Their stripes come in 
      different patterns, unique to each individual. They are generally social 
      animals that live in small harems to large herds. Unlike their closest 
      relatives the horses and donkeys, zebras have never been truly domesticated."""
    )
  ]