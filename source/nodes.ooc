import structs/ArrayList
import visitor

Node: abstract class {
    position := ":"
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
    body: ArrayList<Node>

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
    value: Node = EmptyNode new()
    init: func(=value) {}
    init: func ~noValue {}
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
