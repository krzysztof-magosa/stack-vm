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
        let x =  self.code[ip]
        ip += 1
        return x
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
                let a = nextOp()
                try stack.push(frames.peek().load(a))

            case Op.STORE:
                let a = nextOp()
                try frames.peek().store(a, stack.pop())

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
  Op.PUSH, 100,
  Op.STORE, 0,

  Op.PUSH, 200,
  Op.STORE, 1,

  Op.PUSH, 300,

  Op.LOAD, 1,

  Op.ADD,

  Op.PRINT_I,

  Op.HALT
]

let vm = Vm(code: code)
try vm.run()
