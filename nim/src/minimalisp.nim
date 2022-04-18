# Module minimalisp
import strutils
import strformat
import sequtils

type
  List* = ref object
    head*: Node
    tail*: List
  NodeKind* = enum nInt, nString
  Node* = ref object
    case kind*: NodeKind
    of nInt: num*: int
    of nString: str*: string

proc `$`[Node](n: Node): string =
  case n.kind
  of nInt: fmt"{n.num}"
  of nString: n.str

# This must happen after string negotiation
proc space_parens*(s: string): string =
  s.replace("(", " ( ").replace(")", " ) ")

proc chunk(s: string): seq[string] =
  # TODO: this doesn't work for strings, because strings can contain whitespace
  #       and escaped (\) double-quotes.

  # Surround parens by spaces
  s.space_parens.splitWhitespace

proc tokenise(chunk: string): Node =
  Node(kind: nString, str: chunk)
  # TODO: create other kinds of tokens e.g. ints, symbols etc.

proc analyse(tokens: seq[Node]): List =
  if tokens.len == 0:
    List(head: nil, tail: nil)
  elif tokens.len == 1:
    List(head: tokens[0], tail: nil)
  else:
    List(head: tokens[0],
         tail: analyse(tokens[1 .. ^1]))

proc parse*(s: string): List =
  # Split input string into chunks
  let chunks = chunk(s)
  # Turn chunks into tokens
  let tokens = chunks.map(tokenise)
  # Turn list of tokens into an AST
  let tree = analyse(tokens)
  # Return list of tokens
  tree
