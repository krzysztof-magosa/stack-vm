class Frame {
    private var variables = [Int: Int]()
    let returnAddress: Int

    init(returnAddress: Int) {
        self.returnAddress = returnAddress
    }

    func load(_ id: Int) -> Int {
        return variables[id] ?? 0
    }

    func store(_ id: Int, _ value: Int) {
        variables[id] = value
    }
}
