import Foundation

class BoardController {
    // Control board values
    // Modify JSON

    var boards : [String : Board] = [:]

    func getNewBoard() -> String {
        /* do board setup here */
        let board = Board()
        board.fillBoard()
        /* do unique identification here */
        let uuid = UUID().uuidString
        /* assign board to id on the idTable */
        boards[uuid] = board

        return uuid
    }

    func getExistingBoard(id: String) -> Board? {
        return boards[id]
    }
}
