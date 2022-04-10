import unittest
import minimalisp

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("") == [])
  test "should parse a string with one atom as a list with one element":
    check(parse("a").len == 1)
    check(parse("a") == ["a"])
