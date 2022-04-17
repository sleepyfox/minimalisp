# Module minimalisp
import strutils
import strformat

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

proc space_parens(s: string): string =
  s

proc chunk(s: string): seq[string] =
  s.splitWhitespace()

proc tokenise(chunks: seq[string]): List =
  if chunks.len == 0:
    List(head: nil, tail: nil)
  else:
    List(head: Node(kind: nString, str: chunks[0]),
         tail: nil)

proc parse*(s: string): List =
  # Surround parens by spaces
  let spaced_string = space_parens(s)
  # Split input string into chunks
  let chunks = chunk(spaced_string)
  # Turn chunks into tokens
  let tokens = tokenise(chunks)
  # Return list of tokens
  tokens
