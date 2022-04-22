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

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("").head.isNil)
    check(parse("").tail.isNil)

  test "should parse a string with one atom as a list with one atom":
    check(parse("a").tail.isNil)
    check(parse("a").head.str == "a")

  test "should parse 'a b' as a list of two atoms":
    check(parse("a b").head.str == "a")
    check(parse("a b").tail.head.str == "b")
    check(parse("a b").tail.tail.isNil)

  test "parens should be surrounded by spaces":
    check(space_parens("(") == " ( ")
    check(space_parens(")") == " ) ")

  # test "should parse an empty expression as an empty list":
  #   check(parse("()").head.isNil)
  #   check(parse("()").tail.isNil)
