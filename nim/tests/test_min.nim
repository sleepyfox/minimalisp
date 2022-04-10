import unittest
import minimalisp

suite "A minimalisp parser":
  test "should parse the empty string as an empty list":
    check(parse("") == [])
