struct Op {
    // General (00xx)
    static let NOP     = 0x0000
    static let HALT    = 0x0001

    // Data manipulation (01xx)
    static let PUSH    = 0x0101
    static let POP     = 0x0102
    static let DUP     = 0x0103
    static let LOAD    = 0x0104
    static let STORE   = 0x0105
    static let PRINT_I = 0x0199

    // Mathematics (02xx)
    static let ADD     = 0x0201
    static let SUB     = 0x0202
    static let MUL     = 0x0203
    static let DIV     = 0x0204
    static let MOD     = 0x0205

    // Logic
    static let NOT     = 0x0301
    static let AND     = 0x0302
    static let OR      = 0x0303

    // Control flow
    static let CMP_E   = 0x0401
    static let CMP_NE  = 0x0402
    static let CMP_G   = 0x0403
    static let CMP_GE  = 0x0404
    static let CMP_L   = 0x0405
    static let CMP_LE  = 0x0406
    static let JMP     = 0x0411 // jump
    static let JIF     = 0x0412 // jump if
}
