struct Position: Codable {
    let boxIndex : Int
    let cellIndex : Int
    init(boxIndex:Int, cellIndex:Int) {
        self.boxIndex = boxIndex
        self.cellIndex = cellIndex
    }

/*    init(row:Int, col:Int) {
        boxIndex = (row - 1) / 3 * 3 + (col - 1) / 3 + 1
        cellIndex = (row - 1) % 3 * 3 + (col - 1) % 3 + 1
        //        let row = (boxIndex - 1) / 3 * 3 + (cellIndex - 1) / 3 + 1
        //        let col = (boxIndex - 1) % 3 * 3 + (cellIndex - 1) % 3 + 1

    }*/
}

struct Cell: Codable {
    let position: Position
    var value: Int
    
    init(position:Position, value:Int) {
        self.position = position
        self.value = value
    }
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

struct BoardData: Codable {
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
