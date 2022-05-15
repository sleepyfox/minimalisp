# Module minimalisp
import strutils
import strformat
import sequtils

type
  List* = seq[Node]
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

# | input \ state | waiting   | string   | token    | escape | start-exp  | end-exp    |
# | ------------- | --------- | -------- | -------- | ------ | ---------- | ---------- |
# | whitespace    | waiting   | string   | waiting! | string | waiting!   | waiting!   |
# | double-quote  | string    | waiting! | token    | string | string!    | error      |
# | character     | token     | string   | token    | string | token!     | error      |
# | backslash     | error     | escape   | error?   | string | error      | error      |
# | open-paren    | start-exp | string   | token    | string | start-exp! | start-exp! |
# | close-paren   | close-exp | string   | token    | string | end-exp!   | end-exp!   |

# Take a string and divide it up into lexical chunks
# TODO: can probably merge this with tokenise
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

# Take a string chunk and turn it into a Node
proc tokenise*(chunk: string): Node =
  case chunk[0]
  of '"':
    Node(kind: nString, str: chunk[1 .. ^2])
  of '(':
    Node(kind: nOpen)
  of ')':
    Node(kind: nClose)
  of '0' .. '9':
    Node(kind: nInt, num: chunk.parseInt)
  of '-':
    # TODO: edge cases
    if chunk.len > 1 and chunk[1] in '0' .. '9':
      Node(kind: nInt, num: chunk.parseInt)
    else:
      Node(kind: nToken, token: chunk)
  else:
    Node(kind: nToken, token: chunk)
  # TODO: create other kinds of tokens e.g. floats, symbols etc.

# Take an array of Nodes and produce a tree
proc analyse*(ss: seq[Node]): List =
  # already have implicit result = nil
  type Mode = enum mParse, mSkip

  var
    mode = mParse
    nested = 0

  for i, node in ss:
    case mode
    of mSkip:
      case node.kind
      of nOpen:
        nested += 1
      of nClose:
        nested -= 1
        if nested <= 0:
          mode = mParse
      else:
        discard
    of mParse:
      case node.kind
      of nOpen: # add a new tree node with full expression
        result.add Node(kind: nList, tree: analyse(ss[(i + 1) .. ^1]))
        mode = mSkip
        nested = 1
      of nClose:
        return result
      else:
        result.add node

# Stitch all the pieces of the parsing process together
proc parse*(s: string): List =
  # Split input string into chunks
  let chunks = chunk(s)
  # Turn chunks into tokens
  let tokens = chunks.map(tokenise)
  # Turn list of tokens into an AST
  let tree = analyse(tokens)
  # Return list of tokens
  tree
