import nodes, xml
import structs/[ArrayList,HashMap]

Visitor: class {
    
    indent := 0
    current := Element new("nxml")
    init: func {}

    visitBinaryOp: func(node: BinaryOp) {
        newElem := Element new("o")
        current addChild(newElem)
        current = newElem
        
        current attributes = Attributes new(node op)       
        node e1 accept(this)
        node e2 accept(this)
        current = current root
    }
       
    visitBlock: func (node: Block) {
        node body each(|elem| elem accept(this))
    }
    
    _constructArgumentString: func(args: ArrayList<String>) -> String {
        l := 0 // total length of all args
        args each(|s| l += s length())
        attrsString := String new(Buffer new(l + args size - 1)) // for the ':'
        i := 1
        for (s in args) {
            attrsString = attrsString append(s)
            if (i != args size) {
                attrsString = attrsString append(":")
                i += 1
            }
        }
        attrsString println()
        attrsString
    }

    visitFunctionDecl: func(node: FunctionDecl) {
        newElem := Element new("function")
        current addChild(newElem)
        current = newElem
        current attributes = Attributes new(_constructArgumentString(node args))
        node body each(|elem| elem accept(this))
        current = current root
    }

    visitIdentifier: func (node: Identifier) {
        newElem := Element new("v")
        newElem attributes = Attributes new(node value)
        current addChild(newElem)
    }
    
    visitReturn: func(node: Return) {}
        
    visitStringLiteral: func(node: StringLiteral) {
        newElem := Element new("s")
        newElem attributes = Attributes new(node value)
        current addChild(newElem)
    }
    
    visitFloatLiteral: func(node: FloatLiteral) {
        newElem := Element new("f")
        newElem attributes = Attributes new(node value toString())
        current addChild(newElem)
    }
    
    visitIntegerLiteral: func(node: IntegerLiteral) {
        newElem := Element new("i")
        newElem attributes = Attributes new(node value toString())
        current addChild(newElem)
    }

    visitParenthis: func(node: Parenthis) {
        newElem := Element new("p")
        current addChild(newElem)
        current = newElem
        node child accept(this)
        current = current root
    }
             
    visitCall: func(node: Call) {
        newElem := Element new("c")
        current addChild(newElem)
        current = newElem
        node fName accept(this)
        node args each(|elem| elem accept(this))
    }

    visitAST: func(node: Node) {
        node accept(this)
    }
    write: func -> String {
        r := current 
        while (!r root instanceOf?(EmptyNode)) {
            r = r  root
        }
        xmlToString(r)
    }
}




