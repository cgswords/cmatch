# cmatch
A derivative of pmatch with added features and niceties. This is a simple linear pattern matcher.

It is efficient (generates code at macro-expansion time) and simple: it should work on any R5RS Scheme system.

## Grammar

    (cmatch exp <clause> ...[<else-clause>])
    <clause> ::= (<pattern> <guard|guard-with> exp ...)
    <else-clause> ::= (else exp ...)
    <guard> ::= boolean exp | ()
    <guard-with> ::= <symbol> [boolean exp]* | ()
    <pattern> :: =
        ,var  -- matches always and binds the var
                 pattern must be linear! No check is done
        'exp  -- comparison with variable bound to exp (using equal?)
        exp   -- comparison with exp (using equal?)
        (<pattern1> <pattern2> ...) -- matches the list of patterns
        (<pattern1> . <pattern2>)  -- ditto
        ()    -- matches the empty list

Modified by Adam C. Foltzer for R6RS compatibility

Modified by Cameron Swords to:
- remove all the thunks for efficiency!
- provide quote support. We can match on bound variables now!
- add `guard-with` at Jason Hemann's request.
