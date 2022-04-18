import unittest
import minimalisp

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
