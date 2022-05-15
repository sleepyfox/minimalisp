import unittest
import minimalisp

# string -> chunks: string[]
suite "A chunker":
  test "should turn an empty input string into an empty seq":
    check(chunk("").len == 0)
  test "should deal with a single token":
    check(chunk("cat").len == 1)
  test "should recognise two tokens separated by whitespace":
    check(chunk("My cat").len == 2)
  test "should extract a string literal delimited by double-quotes":
    check(chunk("""My cat "Spot"""").len == 3)
    check(chunk("""My cat "Spot"""")[2] == "\"Spot\"")
  test "should cope with string literals with spaces":
    check(chunk("""Spot went "Meow meow!"""").len == 3)
  test "should include escaped quotes in a string":
    check(chunk("""a "b\"c" d""")[1] == """"b"c"""")
  test "should recognise an open paren next to a token":
    check(chunk("cat (spot").len == 3)
  test "an open paren in a string should not be an expression":
    check(chunk("""a "b (c" d""").len == 3)
    check(chunk("""a "b (c" d""")[1] == """"b (c"""")
  test "a close paren should be a seperate chunk":
    check(chunk("()").len == 2)
  test "a close paren should end a token":
    check(chunk("a)b").len == 3)

# chunk: string -> Token
suite "A tokeniser":
  test "when given an arbitrary string should return a token node":
    check(tokenise("cat").kind == nToken)
    check(tokenise("cat").token == "cat")
  test "when given a string literal should return a string node":
    check(tokenise(""""meow"""").kind == nString)
    check(tokenise(""""meow"""").str == "meow")
  test "when given an empty string literal should return an empty string node":
    check(tokenise("\"\"").kind == nString)
    check(tokenise("\"\"").str == "")
  test "when given a ( returns an open-expression node":
    check(tokenise("(").kind == nOpen)
  test "when given a ) returns an close-expression node":
    check(tokenise(")").kind == nClose)
  test "when given a positive integer returns an integer node":
    check(tokenise("8").kind == nInt)
    check(tokenise("8").num == 8)
  test "when given a negative integer returns an integer node":
    check(tokenise("-1").kind == nInt)
    check(tokenise("-1").num == -1)

# Token[] -> tree: List
suite "An analyser":
  test "when given an empty node list should return an empty tree":
    check(analyse(@[]).len == 0)
  test "when given a single Node should return a List with one item":
    check(analyse(@[tokenise("cat")])[0].kind == nToken)
    check(analyse(@[tokenise("cat")])[0].token == "cat")
  test "when given two Nodes should return a list of two items":
    let result = analyse(@[tokenise("cat"), tokenise("spot")])
    check(result[0].kind == nToken)
    check(result[0].token == "cat")
    check(result[1].kind == nToken)
    check(result[1].token == "spot")
  test "when given an empty expression should return an empty tree":
    let result = analyse(@[tokenise("("), tokenise(")")])
    # result should be @[List -> empty node]
    check(result[0].kind == nList)
    check(result[0].tree.len == 0)
  test "when given a subexpression returns a tree":
    let result = analyse(@[tokenise("8"),
                           tokenise("("),
                           tokenise("1"),
                           tokenise(")")])
    check(result.len == 2)
    check(result[0].kind == nInt)
    check(result[0].num == 8)

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("").len == 0)

  test "should parse a string with one atom as a list with one atom":
    let result = parse("a")
    check(result.len == 1)
    check(result[0].kind == nToken)
    check(result[0].token == "a")

  test "should parse 'a b' as a list of two atoms":
    let result = parse("a b")
    check(result.len == 2)
    check(result[0].kind == nToken)
    check(result[0].token == "a")
    check(result[1].kind == nToken)
    check(result[1].token == "b")

  test "should parse an empty expression as the beginning and end of a list":
    let result = parse("()")
    check(result[0].kind == nList)
    check(result[0].tree.len == 0)
