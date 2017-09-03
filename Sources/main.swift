struct Op {
    // General (00xx)
    static let NOP     = 0x0000
    static let HALT    = 0x0001

    // Data manipulation (01xx)
    static let PUSH    = 0x0101
    static let POP     = 0x0102
    static let PRINT_I = 0x0103

    // Mathematics (02xx)
    static let ADD     = 0x0201
    static let SUB     = 0x0202
    static let MUL     = 0x0203
    static let DIV     = 0x0204
    static let MOD     = 0x0205
}

class Vm {
    let code: [Int]
    var ip: Int = 0
    var stack: Stack<Int>
    var running = false

    init(code: [Int]) {
        self.code = code
        self.stack = Stack<Int>(size: 4096)
    }

    func nextOp() -> Int {
        ip += 1
        return self.code[ip]
    }

    func run() throws {
        ip = 0
        running = true

        repeat {
            let op = code[ip]

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

            default:
                print("INVALID OP")
            }

            ip += 1
        } while (running)
    }
}

let code: [Int] = [
  Op.PUSH,
  10,
  Op.PUSH,
  5,
  Op.SUB,
  Op.PRINT_I,
  Op.HALT
]

let vm = Vm(code: code)
try vm.run()
