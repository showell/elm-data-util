module DParser exposing
    ( D(..)
    , parse
    )

{-| This module parses JSON-like text into a custom type
called D.

    @docs D

    @docs parse

-}

import Parser
    exposing
        ( Parser
        , Trailing(..)
        , float
        , int
        , lazy
        , map
        , oneOf
        , run
        , sequence
        , spaces
        )


{-|

    D stands for whatever you want:
        * data
        * dynamic
        * don't know
        * development use only

-}
type D
    = DInt Int
    | DFloat Float
    | DList (List D)


{-| parse turns a JSON-like string
into a value of type D (where D is a custom
type with DInt, DFloat, etc.)
-}
parse : String -> Result String D
parse s =
    case run parseExpr s of
        Ok d ->
            Ok d

        Err _ ->
            Err "could not parse"


parseExpr : Parser D
parseExpr =
    oneOf
        [ parseValue
        , Parser.lazy (\_ -> parseList parseExpr) -- should be parseExpr (not value)
        ]


parseList : Parser D -> Parser D
parseList item =
    sequence
        { start = "["
        , separator = ","
        , spaces = spaces
        , end = "]"
        , item = item
        , trailing = Optional
        }
        |> map DList


parseNumber : Parser D
parseNumber =
    Parser.number
        { int = Just DInt
        , hex = Nothing
        , octal = Nothing
        , binary = Nothing
        , float = Just DFloat
        }


parseValue : Parser D
parseValue =
    oneOf
        [ parseNumber
        ]
