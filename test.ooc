import io/File
import structs/ArrayList
import source/[nodes, visitor]

main: func {
    ast := Block new([Call new(Identifier new("$print"),
                                [
                                    BinaryOp new("+", 
                                        StringLiteral new("HAHA"),
                                        StringLiteral new("!\n")
                                    )
                                ] as ArrayList<Node>)
                       ] as ArrayList<Node>
                      )
    v := Visitor new() 
    v visitAST(ast)
    tree := v write() // String dump
    f := File new("test.neko")
    f write(tree)
}


