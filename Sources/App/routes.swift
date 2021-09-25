import Vapor

/*
 TODO
 - guard lets
 - merging code
 - json encoding
 - property and function access modifiers (public/private)
 - Board class code
 - BoardData struct code + converting from BoardData to Board and vice-versa
 */

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
        /* generate and get new board */
        let id = boardController.getNewBoard()
        /* assign response type to data */
        let body = Response.Body(string: id)
        let response = Response(status: .created, body: body)

        return response
        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
    }
    
    app.get("games", ":id", "cells") { req -> String in

        /* retrieve parameterized id endpoint */
        guard let id = req.parameters.get("id"),
        /* 2d array of cells encoded into json */
              let board = boardController.getExistingBoard(id:id),
              let json = try? board.jsonBoard() else {
            throw Abort(.badRequest, reason: "Failed to encode Board to Json")
        }
        
        return json
    }

    // * Action: Place specified value at in game at boxIndex, cellIndex
    // * Payload: value (null for removing value)
    // * Response: Nothing
    // * Status: 204 No Content
    
    
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        /* retrieve parameterized endpoints as strings and convert to int accordingly */
        guard let id = req.parameters.get("id"),
              let boxIndex = Int(req.parameters.get("boxIndex")!),
              let cellIndex = Int(req.parameters.get("cellIndex")!),
              let cellValue = try? req.content.decode(CellValue.self) else {
            throw Abort(.badRequest, reason: "Failed to encode boxIndex, cellIndex and cellValue")
            }

        /*let id = req.parameters.get("id")!
        let boxIndex = Int(req.parameters.get("boxIndex")!) ?? 0
        let cellIndex = Int(req.parameters.get("cellIndex")!) ?? 0
        let cellValue = try req.content.decode(CellValue.self)
        */

        /*******testing...
        let diff = Difficulty.easy
        idTable[id]?.setDifficulty(difficulty:diff)
        idTable[id]?.setModifiableVal()
         */

        /* setting value */
        let board = boardController.getExistingBoard(id:id)
        board?.setVal(boxIndex:boxIndex, cellIndex:cellIndex, val:cellValue.value)
      
        return HTTPStatus.noContent
    }
}
