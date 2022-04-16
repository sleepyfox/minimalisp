import strformat

type
  List = ref object
    head: Node
    tail: List
  NodeKind = enum nInt, nString
  Node = object
    case kind: NodeKind
    of nInt: num: int
    of nString: str: string

proc `$`[Node](n: Node): string =
  case n.kind 
  of nInt: fmt"{n.num}"
  of nString: n.str

let l = List(head: Node(kind: nInt, num: 0), tail: List(head: Node(kind: nString, str: "Hi!"), tail: nil))

if l.tail.isNil:
  echo("tail is empty")
else:
  echo(fmt"tail is {l.tail.head}")

echo(fmt"list head is {l.head.num}")
