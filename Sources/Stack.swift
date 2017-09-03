enum StackError: Error {
    case full()
    case empty()
}


class Stack<T> {
    var size: Int
    var items: [T]

    init(size: Int) {
        self.size = size
        self.items = [T]()
        self.items.reserveCapacity(size)
    }

    var count: Int {
        return self.items.count
    }

    var isFull: Bool {
        return self.count == self.size
    }

    var isEmpty: Bool {
        return self.count == 0
    }

    func peek() throws -> T {
        guard let item = self.items.last else {
            throw StackError.empty()
        }

        return item
    }

    func pop() throws -> T {
        guard let item = self.items.last else {
            throw StackError.empty()
        }

        self.items.removeLast()
        return item
    }

    func push(_ item: T) throws {
        guard self.count < self.size else {
            throw StackError.full()
        }

        self.items.append(item)
    }
}
