public class BoardController {

    // # of cells to remove by difficulty level
    private let difficultySettings : [Difficulty: Int] = [.easy: 35,
                                                          .medium: 45,
                                                          .hard: 50,
                                                          .hell: 60]

    private let noBoardWithGivenIdErrorReason = "There is no board with the given id."

    private var boards = [Int : Board]()
    private var solutions = [Int : Board]()

    public func getNewBoard(difficulty: Difficulty) -> Int {
        var board = generateBoard()
        let solution = board
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
        solutions[boardId] = solution
        return boardId
    }

    private func getNewBoardId() -> Int {
        let id = Int.random(in:100000...Int.max)
        return boards[id] == nil ? id : getNewBoardId()
    }

    func getExistingBoard(id: Int, filter: Filter) -> Board? {
        guard let board = boards[id] else {
            return nil
        }
        var boardToReturn : Board?
        
        if(filter == .all) {
            boardToReturn = board
        } else if(filter == .incorrect) {
            let board = board.board
            let solution = solutions[id]!
            var solutionCells = [Position : Cell]()
            for box in solution.board {
                for cell in box.cells {
                    solutionCells[cell.position] = cell
                }
            }
            var incorrectCells = Set<Cell>()
            for box in board {
                for cell in box.cells {
                    if(cell.value != nil) {
                        if(solutionCells[cell.position]!.value != cell.value) {
                            incorrectCells.insert(cell)
                        }
                    }
                }
            }
            boardToReturn = Board(cells: Array(incorrectCells))
        } else if(filter == .repeated) {
            var repeatedCells = Set<Cell>()
            // Check in box, check in row, check in col
            for box in board.board {
                let cells = box.cells
                repeatedCells.formUnion(getRepeatedCells(cells: cells))
            }

            for colIndex in 0...8 {
                let cells = getCol(id: id, colIndex: colIndex)
                repeatedCells.formUnion(getRepeatedCells(cells: cells))
            }

            for rowIndex in 0...8 {
                let cells = getRow(id: id, rowIndex: rowIndex)
                repeatedCells.formUnion(getRepeatedCells(cells: cells))
            }

            boardToReturn = Board(cells: Array(repeatedCells))
            
        } else {
            boardToReturn = nil
        }

        return boardToReturn
    }

    private func getRepeatedCells(cells: [Cell]) -> Set<Cell> {
        var repeatedCells = Set<Cell>()
        
        for cellValue in 1...9 {
            let cellsWithValue = cells.filter { $0.value == cellValue }
            if(cellsWithValue.count > 1) {
                repeatedCells.formUnion(cellsWithValue)
            }
        }

        return repeatedCells
    }

    public func isExistingBoard(id: Int) -> Bool {
        return boards[id] != nil
    }

    public func setCellValue(id: Int, boxIndex: Int, cellIndex: Int, value: Int?) {
        guard let board = boards[id] else {
            fatalError(noBoardWithGivenIdErrorReason)
        }
        var newBoard = board
        newBoard.board[boxIndex].cells[cellIndex].value = value
        setBoard(id: id, board: newBoard)
    }

    private func setBoard(id: Int, board: Board) {
        boards[id] = board
    }

    private func getCell(id: Int, position: Position) -> Cell {
        guard let board = boards[id] else {
            fatalError(noBoardWithGivenIdErrorReason)
        }
        return board.board[position.boxIndex].cells[position.cellIndex]
    }

    private func getAllCellPositions() -> [Int : Position] {
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

    private func generateBoard() -> Board {
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
                let cellRowAndColIndexes = convertPositionToCartesianCoordinates(position: cellPosition)
                let cellRow = cellRowAndColIndexes.rowIndex
                let cellCol = cellRowAndColIndexes.colIndex
                let cellValue = randomizedBoardValues[cellRow][cellCol]
                cells.append(Cell(position: cellPosition, value: cellValue))
            }
            let box = Box(cells: cells)
            boxes.append(box)
        }
        let board = Board(board: boxes)
        return board
    }

    private func randomize(values: [[Int]]) -> [[Int]] {
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

    private func generateRow() -> [Int] {
        var values = Set<Int>()
        for value in 1...9 {
            values.insert(value)
        }
        let valuesInRandomOrder = Array(values).shuffled()
        return valuesInRandomOrder
    }

    // TODO, move to struct (and make this func static)
    private func convertPositionToCartesianCoordinates(position: Position) -> CartesianCoordinates {
        let boxIndex = position.boxIndex
        let cellIndex = position.cellIndex
        let row : Int = boxIndex / 3 * 3 + cellIndex / 3
        let col : Int = boxIndex % 3 * 3 + cellIndex % 3
        return CartesianCoordinates(rowIndex: row, colIndex: col)
    }

    // TODO, move to struct (and make this func static)
    func getPositionByCartesianCoordinates() -> [CartesianCoordinates : Position] {
        var positionByCartesianCoordinates = [CartesianCoordinates : Position]()
        for boxIndex in 0...8 {
            for cellIndex in 0...8 {
                let position = Position(boxIndex: boxIndex, cellIndex: cellIndex)
                let cartesianCoordinates = convertPositionToCartesianCoordinates(position: position)
                positionByCartesianCoordinates[cartesianCoordinates] = position
            }
        }
        return positionByCartesianCoordinates
    }

    func getCol(id: Int, colIndex: Int) -> [Cell] {
        let positionByCartesianCoordinates = getPositionByCartesianCoordinates()
        var cells = [Cell]()
        for rowIndex in 0...8 {
            let cartesianCoordinates = CartesianCoordinates(rowIndex: rowIndex, colIndex: colIndex)
            let position = positionByCartesianCoordinates[cartesianCoordinates]!
            cells.append(getCell(id: id, position: position))
        }
        return cells
    }

    func getRow(id: Int, rowIndex: Int) -> [Cell] {
        let positionByCartesianCoordinates = getPositionByCartesianCoordinates()
        var cells = [Cell]()
        for colIndex in 0...8 {
            let cartesianCoordinates = CartesianCoordinates(rowIndex: rowIndex, colIndex: colIndex)
            let position = positionByCartesianCoordinates[cartesianCoordinates]!
            cells.append(getCell(id: id, position: position))
        }
        return cells
    }
}

extension Array {
    /**
     Returns a new array with the first elements up to specified distance being shifted to the end of the collection. If the distance is negative, returns a new array with the last elements up to the specified absolute distance being shifted to the beginning of the collection.
     If the absolute distance exceeds the number of elements in the array, the elements are not shifted.
     */
    public func shift(withDistance distance: Int = 1) -> Array<Element> {
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
