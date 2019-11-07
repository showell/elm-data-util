module CodeSample exposing
    ( formatCode
    , factorial
    )

{-| This module gives example code snippets
using elm-syntax-dsl. It also provides a
little convenience wrapper for pretty-printing.

@docs formatCode

@docs factorial

-}

import Elm.CodeGen as CG
import Elm.Pretty
import Pretty


{-| use Elm.Pretty to print out code
in nicely formatted style
-}
formatCode : CG.Expression -> String
formatCode code =
    code
        |> Elm.Pretty.prettyExpression
        |> Pretty.pretty 120


{-| factorial (recursive style)
-}
factorial : String
factorial =
    let
        n =
            CG.val "n"

        zero =
            CG.int 0

        one =
            CG.int 1

        nEqualZero =
            CG.opApply "==" CG.infixNon n zero

        nMinusOne =
            CG.opApply "-" CG.infixNon n one
                |> CG.parens

        f =
            CG.fun "factorial"

        facNminusOne =
            CG.apply [ f, nMinusOne ]

        elseExpr =
            CG.opApply "*" CG.infixNon n facNminusOne

        code =
            CG.ifExpr nEqualZero one elseExpr
    in
    formatCode code
