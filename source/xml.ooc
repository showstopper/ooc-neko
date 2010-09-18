import io/BufferWriter
import structs/[ArrayList, HashMap]

Writer: class extends BufferWriter {
    visitor: Visitor
    indent := 0
    
    init: func(=visitor) { super() }
    indApp: func(s: String) { 
        tmp := " " times(indent) + s
        write(tmp _buffer data as Char*, tmp length()) 
    }
    app: func ~Node(n: Node) { n accept(visitor) }

    nl: func {
        write('\n')
    }

    app: func(s: String) {
        write(s _buffer data as Char*, s length())
    }
}

Visitor: class {
    current: Writer
    init: func {
        current = Writer new(this)
    }
    visitStringLiteral: func(node: StringLiteral) { 
        current app(node value)    
    }
    
    visitElement: func(node: Element) {
        current indApp("<" + node tag)
        node attributes accept(this)
        if (node children empty?()) {
            if (!node content instanceOf?(EmptyNode)) {
                node content accept(this)
                current app("</" + node tag + ">")
            } else {
                current app("/>")
            } 
        } else {
            current app(">"). nl()
            current indent += 4
            node children each(|n| n accept(this); current nl())
            current indent -= 4
            current indApp("</" + node tag + ">")
        }

    }

    visitAttributes: func(node: Attributes) {
        current app(" ")
        for (key in node attrs getKeys()) {
            current app(key + "=\""+ node attrs get(key) + "\" ")
        }
    }

    write: func(n: Element) -> Buffer {
        n accept(this)
        current buffer 
    }
}
Node: abstract class {
    init: func {}
    accept: abstract func(v: Visitor) {}
}

EmptyNode: class extends Node {
    init: func {}
    accept: func(v: Visitor) {}
}

Attributes: class extends Node {
    attrs := HashMap<String, String> new()
    attrs["p"] = ":"
    init: func(val: String) { // evil hack, maybe Element should have some "default" attrs?
        attrs["v"] = val    
    }
    accept: func(v: Visitor) {
        v visitAttributes(this)
    }
}

StringLiteral: class extends Node {
    value: String
    init: func(=value) {}
    accept: func(v: Visitor) {
        v visitStringLiteral(this)
    }
}

Element: class extends Node {

    tag: String
    content: Node = EmptyNode new()
    attributes: Node 
    attributes = EmptyNode new()
    children := ArrayList<Node> new()
    root: Node = EmptyNode new()

    init: func(=tag, =content, =attributes) {}
    init: func ~justTag(=tag) {}

    addChild: func(node: Element) {
        children add(node)
        node root = this
    }

    accept: func(v: Visitor) {
        v visitElement(this)
    }
}

xmlToString: func(e: Element) -> String {
    v := Visitor new()
    v write(e) toString()
}

