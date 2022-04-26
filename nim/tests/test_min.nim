import unittest
import minimalisp

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

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("").head.isNil)
    check(parse("").tail.isNil)

  test "should parse a string with one atom as a list with one atom":
    check(parse("a").tail.isNil)
    check(parse("a").head.token == "a")

  test "should parse 'a b' as a list of two atoms":
    check(parse("a b").head.token == "a")
    check(parse("a b").tail.head.token == "b")
    check(parse("a b").tail.tail.isNil)

  # test "should parse an empty expression as an empty list":
  #   check(parse("()").head.isNil)
  #   check(parse("()").tail.isNil)
