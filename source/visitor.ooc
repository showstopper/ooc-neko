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
        newElem := Element new("b")
        current addChild(newElem)
        current = newElem
        node body each(|elem| elem accept(this))
        current = current root
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
        node body accept(this) 
        current = current root
    }

    visitIdentifier: func (node: Identifier) {
        newElem := Element new("v")
        newElem attributes = Attributes new(node value)
        current addChild(newElem)
    }
    
    visitReturn: func(node: Return) {
        newElem := Element new("return")
        current addChild(newElem)
        current = newElem
        node accept(this)
        current = current root
    }
        
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

    visitFieldAccess: func(node: FieldAccess) {
        newElem := Element new("q")
        newElem attributes = Attributes new(node field)
        current addChild(newElem)
        current = newElem
        node obj accept(this)
        current = current root
    }

    visitArrayAccess: func(node: ArrayAccess) {
        newElem := Element new("a")
        current addChild(newElem)
        current = newElem
        node obj accept(this)
        node index accept(this)
        current = current root
    }

    visitVar: func(node: Var) {
        /*
        <var>
            <v p=":" v="x" >
                <i p=":" v="42" />
            </v>
        </var>
        */
        newElem := Element new("var")
        newElem attributes = Attributes new("")
        current addChild(newElem)
        current = newElem
        for (key in node vars getKeys()) {
            value := node vars[key]
            
            newElem = Element new("v")
            newElem attributes = Attributes new(key)
            current addChild(newElem)
            current = newElem
            
            value accept(this) // no matter if empty or not
            current = current root
        }
        current = current root
    }

    visitWhile: func(node: While) {
        newElem := Element new("while")
        current addChild(newElem)
        current = newElem
        node cond accept(this)
        node body accept(this) 
        current = current root
    }

    visitDoWhile: func(node: DoWhile) {
        newElem := Element new("do")
        current addChild(newElem)
        current = newElem
        node body accept(this)
        node cond accept(this)
        current = current root
    }

    visitIf: func(node: If) {
        newElem := Element new("if")
        current addChild(newElem)
        current = newElem
        node cond accept(this)
        node _if accept(this)
        node _else accept(this)
        current = current root
    }

    visitTry: func(node: Try) {
        newElem := Element new("if")
        newElem attributes = Attributes new(node excp)
        current addChild(newElem)
        current = newElem
        node _try accept(this)
        node _catch accept(this)
        current = current root
    }
    
    visitBreak: func(node: Break) {
        newElem := Element new("break")
        current addChild(newElem)
        current = newElem
        node value accept(this)
        current = current root
    }

    visitContinue: func(node: Continue) {
        newElem := Element new("continue")
        current addChild(newElem)
    }

    visitNext: func(node: Next) {
        newElem := Element new("next")
        current addChild(newElem)
        current = newElem
        node e1 accept(this)
        node e2 accept(this)
        current = current root
    }
     
    visitLabel: func(node: Label) {
        newElem := Element new("label")
        newElem attributes = Attributes new(node label)
        current addChild(newElem)
    }

    visitSwitch: func(node: Switch) {
        newElem := Element new("switch")
        current addChild(newElem)
        current = newElem
        node cond accept(this)
        for (key in node cases getKeys()) {
            newElem = Element new("case")
            current addChild(newElem)
            current = newElem
            key accept(this)
            node cases[key] accept(this)
            current = current root
        }
        current = current root
    } 
    visitObject: func(node: _Object) {
        newElem := Element new("object")
        current addChild(newElem)
        current = newElem
        for (key in node fields getKeys()) {
            value := node fields get(key)
            
            newElem = Element new("v")
            newElem attributes = Attributes new(key)
            current addChild(newElem)
            current = newElem
            
            value accept(this) // no matter if empty or not
            current = current root
        }
        current = current root
    }
     
    visitNeko: func(node: Neko) {
        newElem := Element new("neko")
        newElem content = node code
        current addChild(newElem)
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




