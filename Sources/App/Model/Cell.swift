class Cell: Hashable, Equatable {
    public let position: Position
    private(set) var possibilities: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    private(set) var value: Int? = nil

    init(position: Position, value: Int?) {
        self.position = position
        if(value != nil) {
            self.value = value
        }
    }

    init(position: Position) {
        self.position = position
    }

    func setValue(value: Int) {
        self.value = value
    }

    func removePossibility(value: Int) {
        possibilities.remove(value)
    }
    
    func isFilled() -> Bool {
        return value != nil
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }

    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.position == rhs.position && lhs.value == rhs.value
    }
}
