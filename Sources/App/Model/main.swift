func collectionTest() {
    let board = Collection()
    for row in 1...9 {
        for col in 1...9 {
            let cell = Cell(position: Position(row: row, col: col))
            board.addCell(cell)
            print("Creating cell at \(row), \(col)")
        }
    }
}

func generateBoardTest() {
    let board = Board()
    board.generate()
    board.log()
}
generateBoardTest()

// Cell a at 1, 1
// Cell b at 1, 1

// board.getCell(position: Position(row: 1, col: 1))!.setValue(value: 9)
// print(board.getCell(position: Position(row: 1, col: 1))!.value!)

// let a = Cell(position: Position(row: 1, col: 1)
// let b = Cell(position: Position(row: 1, col: 1)
