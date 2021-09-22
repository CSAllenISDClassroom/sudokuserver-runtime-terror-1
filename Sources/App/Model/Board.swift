import Vapor

enum Difficulty {
    case easy
    case medium
    case hard
}

class Board {

    // 10 x 10 grid is used to easily access elements 1-9, while skipping element 0
    // 0's are used to represent empty cells, as 0's are an unused value
    // grid is contantly modified, boolGrid checks modifiable values, filledBoard is the board used to generate different difficulties
    private var grid = Array(repeating: Array(repeating: 0, count: 10), count: 10)
    private var boolGrid = Array(repeating: Array(repeating: false, count: 10), count: 10)
    private var filledBoard = Array(repeating: Array(repeating: 0, count: 10), count: 10)
    
    init() {}

    func setVal(row:Int, col:Int, val:Int) {
        if boolGrid[row][col] {
            grid[row][col] = val
        }
    }

    func setVal(boxIndex:Int, cellIndex:Int, val:Int) {
        let row = (boxIndex - 1) / 3 * 3 + (cellIndex - 1) / 3 + 1
        let col = (boxIndex - 1) % 3 * 3 + (cellIndex) % 3 
        if boolGrid[row][col] {
            grid[row][col] = val
        }
    }
    
    private func checkCell(row:Int, col:Int) -> Set<Int> {   // checks and returns a set of valid values in a cell
        var validVal : Set = [1, 2, 3, 4, 5, 6, 7, 8, 9]

        for cols in 1 ... 9 {
            let invalidVal = grid[row][cols]
            validVal.remove(invalidVal)
        }

        for rows in 1 ... 9 {
            let invalidVal = grid[rows][col]
            validVal.remove(invalidVal)
        }

        for boxRows in 1 ... 3 {
            for boxCols in 1 ... 3 {
                let invalidVal = grid[boxRows + 3 * ((row - 1) / 3)][boxCols + 3 * ((col - 1) / 3)]
                validVal.remove(invalidVal)
            }
        }
        return validVal
    }
    
    /***** box/cell positions on board/box *****
           1   2   3
           4   5   6
           7   8   9
     */
     
    private func fillBox(box:Int) {
        var emptyCells : Set = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let boxGridRow = (box - 1) / 3               // set position of chosen box
        let boxGridCol = (box - 1) % 3

        for _ in 1 ... 9 {
            let cell = emptyCells.randomElement()!
            let boxRow = (cell - 1) / 3 + 1          // set position relative to chosen box
            let boxCol = (cell - 1) % 3 + 1

            let row = boxGridRow * 3 + boxRow        // set actual position
            let col = boxGridCol * 3 + boxCol
            let possibleVals = checkCell(row:row, col:col)

            let val = possibleVals.randomElement()!
            grid[row][col] = val
            
            emptyCells.remove(cell)
        }
    }

    private func isValidVal(row:Int, col:Int, val:Int) -> Bool {
        if checkCell(row:row, col:col).contains(val) {
            return true
        } else {
            return false
        }
    }

// Helper function for backtracking to track position of empty cell
    private func emptyCellPosition() -> [Int] {
        for row in 1 ... 9 {
            for col in 1 ... 9 {
                if grid[row][col] == 0 {
                    return [row, col]
                }
            }
        }
        return [0, 0]
    }

    private func backtracking() -> Bool {
        let position = emptyCellPosition()
        let row = position[0]
        let col = position[1]

        // row 0 assumes that all values are filled in the sudoku board
        if row == 0 {
            return true
        }

        for candidate in 1 ... 9 {
            if isValidVal(row:row, col:col, val:candidate) {
                grid[row][col] = candidate

                // recursion
                if backtracking() {
                    return true
                }
                
                grid[row][col] = 0
            }
        }
        return false
    }
    
    func fillBoard() {
        fillBox(box:1)
        fillBox(box:5)
        fillBox(box:9)
        if backtracking() {
            printBoard()
        }
        filledBoard = grid
    }
    
    private func subtractBoard(deletedVal:Int) {
        var emptyVal = 0
        while emptyVal < deletedVal {
            let row = Int.random(in:1 ... 9)
            let col = Int.random(in:1 ... 9)
            if grid[row][col] != 0 {
                grid[row][col] = 0
                emptyVal += 1
            }
        }
    }

    func setModifiableVal() {
        for row in 1 ... 9 {
            for col in 1 ... 9 {
                if grid[row][col] == 0 {
                    boolGrid[row][col] = true
                } else {
                    boolGrid[row][col] = false
                }
            }
        }
    }

    func setDifficulty(difficulty:Difficulty) {
        grid = filledBoard
        switch(difficulty) {
        case .easy:
            subtractBoard(deletedVal:40)
            break
        case .medium:
            subtractBoard(deletedVal:50)
            break
        case .hard:
            subtractBoard(deletedVal:60)
            break
        }
    }
    
    func checkBoard() -> Bool {
        for row in 1 ... 9 {
            for col in 1 ... 9 {
                let val = grid[row][col]
                if  isValidVal(row:row, col:col, val:val) {
                    return false
                }
            }  
        }
        return true
    }
        
    func getBoard() -> [[Int]] {
        return grid
    }

    func printBoard() {
        for row in 1 ... 9 {
            for col in 1 ... 9 {
                print(grid[row][col], terminator: " ")
            }
            print("")
        }
    }

    func jsonBoard() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(grid)
        return String(data: data, encoding: .utf8)!
    }
}
