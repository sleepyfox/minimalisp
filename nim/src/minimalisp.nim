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

const stt =
  [[1,2],
   [3,4]]

# | input \ state | waiting   | string   | token    | escape | start-exp  | end-exp    |
# | ------------- | --------- | -------- | -------- | ------ | ---------- | ---------- |
# | whitespace    | waiting   | string   | waiting! | string | waiting!   | waiting!   |
# | double-quote  | string    | waiting! | token    | string | string!    | error      |
# | character     | token     | string   | token    | string | token!     | error      |

# | backslash     | error     | escape   | error?   | string | error      | error      |
# | open-paren    | start-exp | string   | token    | string | start-exp! | start-exp! |
# | close-paren   | close-exp | string   | token    | string | end-exp!   | end-exp!   |

proc chunk*(s: string): seq[string] =
  var
    acc = ""
    state = "waiting"
  for c in s:
    case state
    of "waiting":
      case c
      of ' ', '\n', '\t':
        discard
      of '(':
        result.add("(")
      of '"':
        state = "string"
        acc.add(c)
      else:
        state = "token"
        acc.add(c)
    of "string":
      case c
      of '"':
        acc.add(c)
        result.add(acc)
        acc = ""
        state = "waiting"
      of '\\':
        state = "escape"
      else:
        acc.add(c)
    of "escape":
      acc.add(c)
      state = "string"
    of "token":
      case c
      of ' ', '\n', '\t':
        result.add(acc)
        acc = ""
        state = "waiting"
      else:
        acc.add(c)

  if acc.len > 0: # deal with a trailing token
    result.add(acc)

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
