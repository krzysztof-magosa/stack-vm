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

enum VmError: Error {
    case unknownComparison
}

class Vm {
    let code: [Int]
    var ip: Int = 0
    var stack = Stack<Int>(size: 4096)
    var frames = Stack<Frame>(size: 256)
    var running = false

    init(code: [Int]) {
        self.code = code
    }

    func asBool(_ a: Int) -> Bool {
        return a != 0
    }

    func asInt(_ a: Bool) -> Int {
        return (a == true) ?  1 : 0
    }

    func nextOp() -> Int {
        ip += 1
        return self.code[ip]
    }

    func run() throws {
        ip = 0
        try self.frames.push(Frame(returnAddress: 0))
        running = true

        repeat {
            let op = code[ip]
            ip += 1

            switch (op) {
                // General
            case Op.NOP:
                print("NOP")

            case Op.HALT:
                print("HALT")
                running = false

                // Data manipulation
            case Op.PUSH:
                try stack.push(nextOp())

            case Op.POP:
                try _ = stack.pop()

            case Op.DUP:
                try stack.push(stack.peek())

            case Op.LOAD:
                break

            case Op.STORE:
                break

            case Op.PRINT_I:
                let a = try stack.pop()
                print("\(a)")

                // Mathematics
            case Op.ADD:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(a + b)

            case Op.SUB:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(a - b)

            case Op.MUL:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(a * b)

            case Op.DIV:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(a / b)

            case Op.MOD:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(a % b)

            case Op.NOT:
                let a = try stack.pop()
                try stack.push(asInt(!asBool(a)))

            case Op.AND:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(asInt(asBool(a) && asBool(b)))

            case Op.OR:
                let b = try stack.pop()
                let a = try stack.pop()
                try stack.push(asInt(asBool(a) || asBool(b)))

                // Control flow
            case Op.CMP_E, Op.CMP_NE, Op.CMP_G, Op.CMP_GE, Op.CMP_L, Op.CMP_LE:
                let b = try stack.pop()
                let a = try stack.pop()

                try stack.push(asInt(compare(op, a, b)))

            case Op.JMP:
                ip = try stack.pop()

            case Op.JIF:
                let a = try stack.pop()
                if (asBool(a)) {
                    ip = try stack.pop()
                }

            default:
                print("INVALID OP")
            }
        } while (running)
    }

    func compare(_ op: Int, _ a: Int, _ b: Int) throws -> Bool {
        switch(op) {
        case Op.CMP_E:
            return a == b

        case Op.CMP_NE:
            return a != b

        case Op.CMP_G:
            return a > b

        case Op.CMP_GE:
            return a >= b

        case Op.CMP_L:
            return a < b

        case Op.CMP_LE:
            return a <= b

        default:
            throw VmError.unknownComparison
        }
    }
}

let code: [Int] = [
  Op.PUSH,
  4,
  Op.PUSH,
  5,
  Op.CMP_L,
  Op.PRINT_I,
  Op.HALT
]

let vm = Vm(code: code)
try vm.run()
