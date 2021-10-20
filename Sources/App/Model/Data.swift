struct Position: Codable {
    let boxIndex: Int
    let cellIndex: Int
}

struct Cell: Codable {
    let position: Position
    var value: Int?
}
struct Box: Codable {
    var cells: [Cell]

    init(cells: [Cell]) {
        self.cells = cells
    }

    init(boxIndex: Int) {
        var cells = [Cell]()
        for cellIndex in 0 ..< 9 {
            cells.append(Cell(position: Position(boxIndex: boxIndex, cellIndex: cellIndex), value: cellIndex))
        }
        self.cells = cells
    }
}

struct Board: Codable {
    var board: [Box]

    init() {
        var board = [Box]()
        for boxIndex in 0 ..< 9 {
            board.append(Box(boxIndex: boxIndex))
        }
        self.board = board
    }

    init(board: [Box]) {
        self.board = board
    }
}

enum Difficulty {
    case easy
    case medium
    case hard
    case hell
}

enum Filter {
    case all
    case repeated
    case incorrect
}
