# Module minimalisp
import strutils
import strformat
import sequtils

type
  List* = ref object
    head*: Node
    tail*: List
  NodeKind* = enum nInt, nString, nToken, nOpen, nClose, nList
  Node* = ref object
    case kind*: NodeKind
    of nInt: num*: int
    of nString: str*: string
    of nToken: token*: string
    of nOpen: discard
    of nClose: discard
    of nList: tree*: List

proc `$`*[Node](n: Node): string =
  case n.kind
  of nInt: fmt"{n.num}"
  of nString: n.str
  of nToken: n.token
  of nOpen: "("
  of nClose: ")"
  of nList: $n.tree

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
  # This is fairly straighforward, if wordy, code.
  # TODO: refactor to something nicer.
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
      of ')':
        result.add(")")
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
      of ')':
        result.add(acc)
        result.add(")")
        state = "waiting"
      else:
        acc.add(c)

  if acc.len > 0: # deal with a trailing token
    result.add(acc)

proc tokenise*(chunk: string): Node =
  case chunk[0]
  of '"':
    Node(kind: nString, str: chunk[1 .. ^2])
  of '(':
    Node(kind: nOpen)
  of ')':
    Node(kind: nClose)
  else:
    Node(kind: nToken, token: chunk)
  # TODO: create other kinds of tokens e.g. ints, symbols etc.

# Currently this just creates a flat list
# it needs to create a tree
proc analyse*(tokens: seq[Node]): List =
  var list = new(List)
  var listp = list
  var lastp: List

  for node in tokens:
    listp.head = node
    listp.tail = new(List)
    lastp = listp
    listp = listp.tail

  if tokens.len > 0:
     lastp.tail = nil # remove trailing new(List)
  list


proc parse*(s: string): List =
  # Split input string into chunks
  let chunks = chunk(s)
  # Turn chunks into tokens
  let tokens = chunks.map(tokenise)
  # Turn list of tokens into an AST
  let tree = analyse(tokens)
  # Return list of tokens
  tree
