import Vapor

let boardController = BoardController()
let encoder = JSONEncoder()

struct CellValue : Content {
    let value : Int
}

func routes(_ app: Application) throws {
    app.get { req in
        return "Server side working!"
    }

    // * Action: Creates a new game and associated board
    // * Payload: None
    // * Response: Id uniquely identifying a game
    // * Status code: 201 Created
    
    app.post("games") { req -> Response in
        /* do board setup here */
        let board = Board()
        board.fillBoard()
        /* do unique identification here */
        let uuid = UUID().uuidString
        /* assign board to id on the idTable */
        idTable[uuid] = board
        /* assign response type to data */
        let body = Response.Body(string: uuid)
        let response = Response(status: .created, body: body)
        return response
    }

    // * Action: None
    // * Payload: None
    // * Response: cells
    // * Status code: 200 OK
    
    app.get("games", ":id", "cells") { req -> String in

        /* retrieve parameterized id endpoint */
        let id = req.parameters.get("id")!
        /* 2d array of cells encoded into json */
        let json = try idTable[id]?.jsonBoard() ?? "{\"status\": \"error\"}"
        return json
    }

    // * Action: Place specified value at in game at boxIndex, cellIndex
    // * Payload: value (null for removing value)
    // * Response: Nothing
    // * Status: 204 No Content
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        /* retrieve parameterized endpoints as strings and convert to int accordingly */
        let id = req.parameters.get("id")!
        let boxIndex = Int(req.parameters.get("boxIndex")!) ?? 0
        let cellIndex = Int(req.parameters.get("cellIndex")!) ?? 0
        let cellValue = try req.content.decode(CellValue.self)
/*******testing...
        let diff = Difficulty.easy
        idTable[id]?.setDifficulty(difficulty:diff)
        idTable[id]?.setModifiableVal()
*/
        /* setting value */
        idTable[id]?.setVal(boxIndex:boxIndex, cellIndex:cellIndex, val:cellValue.value)
      
        return HTTPStatus.noContent
    }
}
