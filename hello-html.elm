import Html exposing (..)
import Html.Attributes exposing (..)
import List
import Shared.Styles as Styles

{- This script generates some HTML.  It's not an application; it doesn't
take in put and nothing on the page changes.
-}
main =
    div [Styles.styles] [
        h1 [] [text "Learning Elm"]
      , div [] [
            p [] [text 
                """This script generates some HTML.  It's not an application; it doesn't take input and nothing on the page changes.  
                It is still pretty cool because I can declare variables and functions to avoid code repetition and keep things cleaner.  
                But this is just the start of Elm's capabilities!  Check out the simple programs below!"""
                ]
          , ol [] [
              linkBullet "simple-app.elm" "A simple pounds-to-kilograms converter.  Takes user input and calculates some output"
            , linkBullet "hiding-sections.elm" "Displays or hides sections based on user input"
            , linkBullet "accordion-example-1.elm" "A simple accordion, basically a different way to hide sections"
            , linkBullet "accordion-example-2.elm" "The same behavior as before, but with the accordion logic extracted into a reusable module"
            , linkBullet "hello-http.elm" "Makes an HTTP request to retrieve a JSON file and display the contents"
            , linkBullet "embedded-program.elm" "Embeds a standalone elm program into a section of a larger program"
          ]
        ]
    ]

linkBullet url displayText =
    li [] [
        a [href url] [text displayText]
    ]

fizzbuzz = 
    let 
        numberToLine i =
            if i % 15 == 0 then
                "FizzBuzz"
            else if i % 3 == 0 then
                "Fizz"
            else if i % 5 == 0 then
                "Buzz"
            else 
                toString i

        lineToDiv line = 
            div [] [text line]
    in
        div [] ([1..100] 
            |> List.map numberToLine
            |> List.map lineToDiv)