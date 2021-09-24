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
<<<<<<< HEAD
        return response
        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
    }

    app.get("games", ":id", "cells") { req -> Response in
        guard let boardId = req.parameters.get("id"),
              let boardData = boardController.getExistingBoard(id: boardId)
        else {
            throw Abort(.badRequest)
        }

        let data = try encoder.encode(boardData.grid)
        let body = Response.Body(string: String(data: data, encoding: .utf8)!)
        let response = Response(status: .ok, body: body)
=======
        
>>>>>>> a81e50dc540b8bc74fc601fd07add4d84f9c6487
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
        let board = boardController.getExistingBoard(id:id)
        let json = try board?.jsonBoard() ?? "{\"status\": \"error\"}"
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
        let board = boardController.getExistingBoard(id:id)
        board?.setVal(boxIndex:boxIndex, cellIndex:cellIndex, val:cellValue.value)
      
        return HTTPStatus.noContent
    }
}
