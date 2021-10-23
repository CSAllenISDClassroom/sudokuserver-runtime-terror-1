import Foundation

class BoardController {
    // Control board values
    // Modify JSON

    var boards : [Int : Board] = [:]

    func getNewBoard() -> Int {
        /* do board setup here */
        let board = Board()
        board.fillBoard()
        /* do unique identification here */
        let id = 123456
        /*  let id = Int.random(in:000000 ... 999999)
            IF LOGIC???
            
         */
        /* assign board to id on the idTable */
        boards[id] = board

        return id
    }

    func getExistingBoard(id: Int) -> Board? {
        return boards[id]
    }

    func isExistingBoard(id: Int) -> Bool {
        return boards[id] != nil
    }
    
    /* assign difficulty by subtracting filled board*/
    func setDifficulty(id: Int, difficulty:Difficulty) {
        switch(difficulty) {
        case .easy:
            boards[id]?.subtractBoard(deletedVal:40)
            break
        case .medium:
            boards[id]?.subtractBoard(deletedVal:45)
            break
        case .hard:
            boards[id]?.subtractBoard(deletedVal:50)
            break
        case .hell:
            boards[id]?.subtractBoard(deletedVal:55)
        }
    }

    /* filter cells by accessing filter logic */
    func getFilteredCells(id: Int, filter:Filter) -> BoardData {
        let boardVal : [[Int]]
        switch(filter) {
        case .all:
            boardVal = boards[id]!.getBoard()
            break
        case .repeated:
            boardVal = boards[id]!.getRepeated()
            break
        case .incorrect:
            boardVal = boards[id]!.getIncorrect()
            break
        }

        // Determined board values are put into defined board structures
        var boxes = [Box]()
        for boxIndex in 0 ... 8 {
            var cells = [Cell]()
            for cellIndex in 0 ... 8 {
                // row, col, val
                let row = (boxIndex - 1) / 3 * 3 + (cellIndex - 1) / 3 + 1
                let col = (boxIndex - 1) % 3 * 3 + (cellIndex - 1) % 3 + 1
                let value = boardVal[row][col]

                // single cell defined and appended to a box
                if value == 0 { 
                let position = Position(boxIndex:boxIndex, cellIndex:cellIndex)
                let cell = Cell(position:position, value:value)
                cells.append(cell)
                }
            }
            let box = Box(cells: cells)
        }
        let board = BoardData(board: boxes)
        return board
    }

    func jsonBoard(board: BoardData) throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(board)
        return String(data: data, encoding: .utf8)!
    }
}

/*
 struct BoardData: Codable {
 let id: String
 let values: [[Int]]
 }

struct BoardId: Codable {
    let id: Int
}
*/
