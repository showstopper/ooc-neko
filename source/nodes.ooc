import structs/[ArrayList,HashMap]
import visitor

Node: abstract class {
    attributes := HashMap<String,String> new()
    attributes["p"] = ":"
    init: func {}
    accept: abstract func(v: Visitor)
}

EmptyNode: class extends Node {
    init: func {}
    accept: func(v: Visitor) {}
}

BinaryOp: class extends Node {

    op := ""
    e1, e2: Node
    init: func (=op, =e1, =e2) {}

    accept: func(v: Visitor) {
        v visitBinaryOp(this)
    }
}

Block: class extends Node {
    body: ArrayList<Node>
    
    init: func { body = ArrayList<Node> new() }
    init: func ~withChildren(=body) {}
    
    addChild: func(child: Node) {
        body add(child)
    }
    accept: func(v: Visitor) {
        v visitBlock(this)
    }
}

FunctionDecl: class extends Node {
    args: ArrayList<String>
    body: Node

    init: func (=args, =body) {}

    accept: func(v: Visitor) {
        v visitFunctionDecl(this)
    }
}

Identifier: class extends Node {
    value := ""
    init: func(=value) {}
    accept: func(v: Visitor) {
        v visitIdentifier(this)
    }
}

Return: class extends Node {
    value: Node
    init: func(value := EmptyNode new()) {
        this value = value
    }
    accept: func(v: Visitor) {
        v visitReturn(this)
    }
}
    
FloatLiteral: class extends Node {
    value := 0.0
    init: func(=value) {}
    accept: func(v: Visitor) {
        v visitFloatLiteral(this)
    }
}

IntegerLiteral: class extends Node {
    value := 0
    init: func(=value) {}
    accept: func(v: Visitor) {
        v visitIntegerLiteral(this)
    }
}

StringLiteral: class extends Node {
    value := ""
    init: func(=value) {}
    accept: func(v: Visitor) {
        v visitStringLiteral(this)
    }
}

Parenthis: class extends Node {
    child: Node
    init: func(=child) {}
    accept: func(v: Visitor) {
        v visitParenthis(this)
    }
}

Call: class extends Node {
    fName: Identifier
    args: ArrayList<Node>
    init: func(=fName, =args) {}
    accept: func(v: Visitor) {
        v visitCall(this)
    }
}

FieldAccess: class extends Node {
    obj: Node
    field: String
    init: func(=obj, =field) {}
    accept: func(v: Visitor) {
        v visitFieldAccess(this)
    }
}

ArrayAccess: class extends Node {
    obj, index: Node
    init: func(=obj, =index) {}
    accept: func(v: Visitor) {
        v visitArrayAccess(this)
    }
}

Var: class extends Node {
    vars: HashMap<String, Node> 
    init: func(=vars) {}
    accept: func(v: Visitor) {
        v visitVar(this)
    }
}

While: class extends Node {
    cond, body: Node
    init: func(=cond, =body) {}
    accept: func(v: Visitor) {
        v visitWhile(this)
    }
}

DoWhile: class extends Node {
    cond, body: Node
    init: func(=cond, =body)
    accept: func(v: Visitor) {
        v visitDoWhile(this)
    }
}

If: class extends Node {
    cond, _if, _else: Node
    init: func(=cond, =_if, _else := EmptyNode new()) {
        this _else = _else
    }
    accept: func(v: Visitor) {
        v visitIf(this)
    }
}

Try: class extends Node {
    excp: String
    _try, _catch: Node
    init: func(=excp, =_try, =_catch) {}
    accept: func(v: Visitor) {
        v visitTry(this)
    }
}

Break: class extends Node {
    value: Node
    init: func(value := EmptyNode new()) {
        this value = value
    }
    accept: func(v: Visitor) {
        v visitBreak(this)
    }
}

Continue: class extends Node {
    init: func {}
    accept: func(v: Visitor) {
        v visitContinue(this)
    }
}

Next: class extends Node {
    e1, e2: Node
    init: func(=e1, =e2) {}
    accept: func(v: Visitor) {
        v visitNext(this)
    }
}

Label: class extends Node {
    label: String
    init: func(=label) {}
    accept: func(v: Visitor) {
        v visitLabel(this)
    }
}

Switch: class extends Node {
    cond, def: Node
    cases: HashMap<Node, Node>
    init: func(=cond, =def, =cases) {}
    accept: func(v: Visitor) {
        v visitSwitch(this)
    }
}

_Object: class extends Node {
    fields: HashMap<String, Node>
    init: func(=fields) {}
    accept: func(v: Visitor) {
        v visitObject(this)
    }
}

Neko: class extends Node {
    code: String
    init: func(=code) {}
    accept: func(v: Visitor) {
        v visitNeko(this)
    }
}

