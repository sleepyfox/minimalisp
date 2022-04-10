# Module minimalisp
import strutils

proc space_parens(s: string): string =
  s

proc chunk(s: string): seq[string] =
  s.splitWhitespace()

proc tokenise(chunks: seq[string]): seq[string] =
  chunks

proc parse*(s: string): seq[string] =
  # Surround parens by spaces
  let spaced_string = space_parens(s)
  # Split input string into chunks
  let chunks = chunk(spaced_string)
  # Turn chunks into tokens
  let tokens = tokenise(chunks)
  # Return list of tokens
  tokens
