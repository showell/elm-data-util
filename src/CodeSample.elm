module CodeSample exposing
    ( formatCode
    , factorial, factorial2, ranks
    )

{-| This module gives example code snippets
using elm-syntax-dsl. It also provides a
little convenience wrapper for pretty-printing.

@docs formatCode


# Examples

In the [examples](https://github.com/showell/elm-data-util/blob/master/src/CodeSample.elm)
I try to really break things down, by
defining little snippets from the bottom up and combining
them into the final code. You may prefer to inline things a bit
more.

@docs factorial, factorial2, ranks

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


binOp expr1 op expr2 =
    -- CG.infixNon may be deprecated eventually
    CG.opApply op CG.infixNon expr1 expr2


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
            binOp n "==" zero

        nMinusOne =
            binOp n "-" one
                |> CG.parens

        f =
            CG.fun "factorial"

        facNminusOne =
            CG.apply [ f, nMinusOne ]

        elseExpr =
            binOp n "*" facNminusOne

        code =
            CG.ifExpr nEqualZero one elseExpr
    in
    formatCode code


{-| factorial using foldl
-}
factorial2 : String
factorial2 =
    let
        n =
            CG.val "n"

        one =
            CG.int 1

        {--We could maybe cheat here and just use CG.fun "List.range",
            but I wanted to demonstrate fqFun, where "fq" is short
            for "fully qualified."
        --}
        listRange =
            CG.fqFun [ "List" ] "range"

        listFoldl =
            CG.fqFun [ "List" ] "foldl"

        range =
            CG.apply [ listRange, one, n ]

        times =
            CG.op "*"

        foldl =
            CG.apply [ listFoldl, times, one ]

        code =
            CG.pipe range [ foldl ]
    in
    formatCode code


{-| convert items to simple rankings like [ 4, 1, 2, 3 ] based
on their order
-}
ranks : String
ranks =
    let
        lst =
            CG.val "lst"

        {--
            Here, we use CG.fun instead of CG.fqFun, just for
            convenience.
        --}
        map =
            CG.fun "List.map"

        sortBy =
            CG.fun "List.sortBy"

        indexedMap =
            CG.fun "List.indexedMap"

        first =
            CG.fun "Tuple.first"

        second =
            CG.fun "Tuple.second"

        pair =
            CG.fun "Tuple.pair"

        n =
            CG.val "n"

        one =
            CG.val "1"

        nPlusOne =
            binOp n "+" one

        incrLambda =
            CG.lambda [ CG.varPattern "n" ] nPlusOne

        code =
            CG.pipe
                lst
                [ CG.apply [ indexedMap, pair ]
                , CG.apply [ sortBy, second ]
                , CG.apply [ map, first ]
                , CG.apply [ indexedMap, pair ]
                , CG.apply [ sortBy, second ]
                , CG.apply [ map, first ]
                , CG.apply [ map, incrLambda ]
                ]
    in
    formatCode code
