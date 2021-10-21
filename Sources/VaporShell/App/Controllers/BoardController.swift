class BoardController {

    // # of cells to remove by difficulty level
    let difficultySettings : [Difficulty: Int] = [.easy: 35,
                                                  .medium: 45,
                                                  .hard: 50,
                                                  .hell: 60]

    var boards = [Int : Board]()

    func getNewBoard(difficulty: Difficulty) -> Int {
        var board = generateBoard()
        var cellNumbersAvailable = Array(1...81)
        let cellsToRemove = getAllCellPositions()
        for _ in 1...difficultySettings[difficulty]! {
            let randomIndex = cellNumbersAvailable.indices.randomElement()!
            let cellNumberToRemove = cellNumbersAvailable.remove(at: randomIndex)
            let cellPositionToRemove = cellsToRemove[cellNumberToRemove]!
            board.board[cellPositionToRemove.boxIndex].cells[cellPositionToRemove.cellIndex].value = nil
        }
        let boardId = getNewBoardId()
        boards[boardId] = board
        return boardId
    }

    func getNewBoardId() -> Int {
        let id = Int.random(in:100000...Int.max)
        return boards[id] == nil ? id : getNewBoardId()
    }

    func getExistingBoard(id: Int) -> Board? {
        return boards[id]
    }

    // TODO implement this function
    func getExistingBoard(id: Int, filter: Filter) -> Board? {
        if(filter == .all) {
            // TODO change to use another method/way
            return getExistingBoard(id: id)
        }

        if(filter == .incorrect) {
            
        }

        if(filter == .repeated) {
            
        }

        // temporary, to make swift compiler happy
        return nil
    }

    func isExistingBoard(id: Int) -> Bool {
        return boards[id] != nil
    }

    func setCellValue(id: Int, boxIndex: Int, cellIndex: Int, value: Int?) {
        guard let board = boards[id] else {
            fatalError("Couldn't find board with id: \(id)")
        }
        var newBoard = board
        newBoard.board[boxIndex].cells[cellIndex].value = value
        setBoard(id: id, board: newBoard)
    }

    func setBoard(id: Int, board: Board) {
        boards[id] = board
    }

    func getAllCellPositions() -> [Int : Position] {
        var possibleCellsToRemove = [Int : Position]()
        var cellCounter = 1
        for boxIndex in 0...8 {
            for cellIndex in 0...8 {
                possibleCellsToRemove[cellCounter] = Position(boxIndex: boxIndex, cellIndex: cellIndex)
                cellCounter += 1
            }
        }
        return possibleCellsToRemove
    }

    func generateBoard() -> Board {
        var boardValues : [[Int]] = []
        let firstRow = generateRow()

        boardValues.append(firstRow)
        for row in 2...9 {
            let previousRow = boardValues[row - 2]
            var currentRow : [Int]
            let specialRows = [4, 7]
            if(specialRows.contains(row)) {
                let firstThreeValues = Array(firstRow[0...2])
                let secondThreeValues = Array(firstRow[3...5])
                let thirdThreeValues = Array(firstRow[6...8])
                let shiftValue = row == 4 ? 1 : 2
                currentRow = firstThreeValues.shift(withDistance: shiftValue)
                currentRow.append(contentsOf: secondThreeValues.shift(withDistance: shiftValue))
                currentRow.append(contentsOf: thirdThreeValues.shift(withDistance: shiftValue))
            } else {
                currentRow = previousRow.shift(withDistance: 3)
            }

            boardValues.append(currentRow)
        }
        let randomizedBoardValues = randomize(values: boardValues)

        var boxes = [Box]()
        for boxIndex in 0...8 {
            var cells = [Cell]()
            for cellIndex in 0...8 {
                let cellPosition = Position(boxIndex: boxIndex, cellIndex: cellIndex)
                let cellRowAndColIndexes = convertBoxCellIndexesToRowAndColIndexes(boxIndex: boxIndex, cellIndex: cellIndex)
                let cellRow = cellRowAndColIndexes.row
                let cellCol = cellRowAndColIndexes.col
                let cellValue = randomizedBoardValues[cellRow][cellCol]
                cells.append(Cell(position: cellPosition, value: cellValue))
            }
            let box = Box(cells: cells)
            boxes.append(box)
        }
        let board = Board(board: boxes)
        return board
    }

    func randomize(values: [[Int]]) -> [[Int]] {
        var values = values
        let firstTriplets = values[0...2].shuffled()
        let secondTriplets = values[3...5].shuffled()
        let thirdTriplets = values[6...8].shuffled()
        let randomlyOrderedTriplets = [firstTriplets, secondTriplets, thirdTriplets].shuffled()
        var randomizedBoard : [[Int]] = []
        for triplet in randomlyOrderedTriplets {
            for row in triplet {
                randomizedBoard.append(row)
            }
        }
        values = randomizedBoard
        return values
    }

    func generateRow() -> [Int] {
        var values = Set<Int>()
        for value in 1...9 {
            values.insert(value)
        }
        let valuesInRandomOrder = Array(values).shuffled()
        return valuesInRandomOrder
    }

    func convertBoxCellIndexesToRowAndColIndexes(boxIndex: Int, cellIndex: Int) -> (row: Int, col: Int) {
        let row : Int = boxIndex / 3 * 3 + cellIndex / 3
        let col : Int = boxIndex % 3 * 3 + cellIndex % 3
        return (row: row, col: col)
    }
}

extension Array {

            /**
                           Returns a new array with the first elements up to specified distance being shifted to the end of the collection. If the distance is negative, returns a new array with the last elements up to the specified absolute distance being shifted to the beginning of the collection.
                                              If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
             */
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
          self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
          self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }

        /**
                   Shifts the first elements up to specified distance to the end of the array. If the distance is negative, shifts the last elements up to the specified absolute distance to the beginning of the array.
                                  If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
         */
    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(withDistance: distance)
    }

}

    // func generateBoard() {
//         let firstBox = generateBox()
//         let boxes = [Box]()
//         boxes.append(firstBox)
//         for _ in 1...2 {
//             guard let previousBox = boxes.last else {
//                 fatalError("Could not find previous box while generating board...")
//             }
//             let newBox = generateNextBox(previousBox: previousBox)
//         }
//     }

//     func generateBox(boxIndex: Int = 0) -> Box {
//         var values = Array(1...9)
//         randomizedValues = values.shuffle()
//         var cells = [Cell]()
//         var cellIndexCounter = 0
//         for value in randomizedValues {
//             let position = Position(boxIndex: boxIndex, cellIndex: cellIndexCounter)
//             cells.append(Cell(position: position, value: value))
//             cellIndexCounter += 1
//         }
        
//         let box = Box(cells: cells)
//         return box
//     }

//     func generateNextBox(previousBox: Box, boxIndexIncrement : Int = 1, cellIndexShift : Int = 3) -> Box {
//         let boxWithUpdatedBoxIndex = changeBoxIndexOfCells(box: previousBox)
//         let box
//     }

//     func changeBoxIndexOfCells(box: Box, boxIndexIncrement: Int = 1) -> Box {
//         for cell in box.cells {
//             let currentPosition = cell.position
//             let newPosition = Position(boxIndex: currentPosition.boxIndex + boxIndexIncrement, cellIndex: currentPosition.cellIndex)
//             cell.position = newPosition
//         }
//         return box
//     }

//     func changeCellIndexOfCells(box: Box, cellIndexShift: Int = 3) -> Box {
//         for cell in box.cells {
//             let currentPosition = cell.position
//             let newPosition = Position(boxIndex: currentPosition.boxIndex, cellIndex: (currentPosition.cellIndex + cellIndexShift) % 9)
//             cell.position = newPosition
//         }
//         return box
//     }
// }
