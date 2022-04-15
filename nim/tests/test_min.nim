import unittest
import minimalisp

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("") == [])
  test "should parse a string with one atom as a list with one atom":
    check(parse("a").len == 1)
    check(parse("a") == ["a"])
  test "should parse 'a b' as a list of two atoms":
    check(parse("a b").len == 2)
    check(parse("a b") == ["a", "b"])
  test "should parse an empty expression as an empty list":
    check(parse("()") == [[]])
