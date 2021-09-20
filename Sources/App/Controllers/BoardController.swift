import Foundation

class BoardController {
    // Control board values
    // Modify JSON

    var boards : [Int : BoardData] = [:]
    var nextBoardId : Int = 0

    func getNewBoard() -> BoardData {
        let board = Board()
        let boardData = BoardData(id: getNextBoardId(), values: board.values)
        boards[boardData.id] = boardData
        return boardData
    }

    func getExistingBoard(id: Int) -> BoardData? {
        return boards[id]
    }

    func updateBoard(data: BoardData) {
        boards[data.id] = data
    }

    func getNextBoardId() -> Int {
        nextBoardId += 1
        return nextBoardId - 1
    }

    func convertBoxCellIndexesToRowAndColIndexes(boxIndex: Int, cellIndex: Int) -> (row: Int, col: Int) {
        let row : Int = boxIndex / 3 * 3 + cellIndex / 3
        let col : Int = boxIndex % 3 * 3 + cellIndex % 3
        return (row: row, col: col)
    }
}

struct BoardData: Codable {
    let id: Int
    let values: [[Int]]
}
