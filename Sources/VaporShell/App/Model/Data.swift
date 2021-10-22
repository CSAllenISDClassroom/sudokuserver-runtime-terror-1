public struct Cell: Codable, Hashable {
    public let position: Position
    public var value: Int?
}

public struct Box: Codable {
    public var cells: [Cell]

    public init(cells: [Cell]) {
        self.cells = cells
    }

    public init(boxIndex: Int) {
        var cells = [Cell]()
        for cellIndex in 0 ..< 9 {
            cells.append(Cell(position: Position(boxIndex: boxIndex, cellIndex: cellIndex), value: cellIndex))
        }
        self.cells = cells
    }
}

struct Board: Codable {
    public var board: [Box]

    public init() {
        var board = [Box]()
        for boxIndex in 0 ..< 9 {
            board.append(Box(boxIndex: boxIndex))
        }
        self.board = board
    }

    public init(board: [Box]) {
        self.board = board
    }

    public init(cells: [Cell]) {
        var boxes = [Box]()
        for boxIndex in 0...8 {
            let boxCells = cells.filter { $0.position.boxIndex == boxIndex }
            boxes.append(Box(cells: boxCells))
        }
        self.board = boxes
    }
}
