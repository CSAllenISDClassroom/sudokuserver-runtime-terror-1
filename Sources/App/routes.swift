import Vapor

let boardController = BoardController()
let encoder = JSONEncoder()

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.post("games") { req -> String in
        let newBoard = boardController.getNewBoard()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(newBoard.id)
        return String(data: data, encoding: .utf8)!
        
        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
    }

    app.get("games", ":id", "cells") { req -> String in
        var boardId : Int = -1

        let rawBoardId = req.parameters.get("id")
        convertOptionalStringToInteger(stringToConvert: rawBoardId, integer: &boardId)

        let rawBoard = boardController.getExistingBoard(id: boardId)
        let board : BoardData
        if(rawBoard != nil) {
            board = rawBoard!
        } else {
            throw Abort(.badRequest)
        }

        let data = try encoder.encode(board.values)
        return String(data: data, encoding: .utf8)!
        
        // * Action: None
        // * Payload: None
        // * Response: cells
        // * Status code: 200 OK
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> String in
        var boardId : Int = -1
        var boxIndex : Int = -1
        var cellIndex : Int = -1
        var value : Int = 0
        
        let rawBoardId = req.parameters.get("id")
        convertOptionalStringToInteger(stringToConvert: rawBoardId, integer: &boardId)
        
        let rawBoxIndex = req.parameters.get("boxIndex")
        convertOptionalStringToInteger(stringToConvert: rawBoxIndex, integer: &boxIndex)

        let rawCellIndex = req.parameters.get("cellIndex")
        convertOptionalStringToInteger(stringToConvert: rawCellIndex, integer: &cellIndex)

        if(!((0...8).contains(boxIndex) && (0...8).contains(cellIndex))) {
            throw Abort(.badRequest)
        }
        
        let rawBoard = boardController.getExistingBoard(id: boardId)
        let boardData : BoardData
        if(rawBoard != nil) {
            boardData = rawBoard!
        } else {
            throw Abort(.badRequest)
        }
        let rawValue = req.body.string
        convertOptionalStringToInteger(stringToConvert: rawValue, integer: &value)
        value = value == -1 ? 0 : value

        let cartesianCoordinates = boardController.convertBoxCellIndexesToRowAndColIndexes(boxIndex: boxIndex, cellIndex: cellIndex)
        let board = Board()
        board.setValues(values: boardData.values)
        board.putValue(row: cartesianCoordinates.row, col: cartesianCoordinates.col, value: value)
        boardController.updateBoard(data: BoardData(id: boardId, values: board.values))
        return "Board updated"
        
        // * Action: Place specified value at in game at boxIndex, cellIndex
        // * Payload: value (null for removing value)
        // * Response: Nothing
        // * Status: 204 No Content
    }
}

func convertOptionalStringToInteger(stringToConvert: String?, integer: inout Int) {
    if(stringToConvert != nil && stringToConvert!.isNumber) {
        integer = Int(stringToConvert!)!
    } else {
        integer = -1
        print("Unable to successfully convert optional string to an integer.")
        // should ideally throw an error here
    }
}

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
