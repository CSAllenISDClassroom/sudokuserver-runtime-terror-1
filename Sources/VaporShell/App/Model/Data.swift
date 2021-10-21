public struct CartesianCoordinates: Hashable {
    public let rowIndex: Int
    public let colIndex: Int
}

public struct Position: Codable, Hashable {
    public let boxIndex: Int
    public let cellIndex: Int
}

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

public enum Difficulty: String {
    case easy
    case medium
    case hard
    case hell
}

public enum Filter: String {
    case all
    case repeated
    case incorrect
}

/// JSON ENCODING ///

public struct BoardId: Codable {
    let id: Int
}

/// JSON DECODING ///

public struct CellValue: Decodable {
    let value: Int?

    func checkValue() -> Bool {
        var goodValues: Set<Int?> = [nil]
        for n in 1...9 {
            goodValues.insert(n)
        }
        return goodValues.contains(value)
    }
}
