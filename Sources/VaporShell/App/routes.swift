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

struct BoardId : Codable {
    let id : Int
}

func routes(_ app: Application) throws {
    app.get { req in
        return  "Server side working!"
    }
    
    app.post("games") { req -> Response in
                  
        guard let rawDifficulty: String = req.query["difficulty"],
              let difficulty = Difficulty(rawValue: rawDifficulty) else {
            throw Abort(.badRequest, reason: "Difficulty specified doesn't match requirements.")
        }
        
        let rawId = boardController.getNewBoard(difficulty: difficulty)
        let constructedId = BoardId(id: rawId)
        guard let data = try? encoder.encode(constructedId),
              let json = String(data: data, encoding: .utf8) else {
            fatalError("Failed to encode BoardId into json.")
        }
        let body = Response.Body(string: json)
        let response = Response(status: .created, body: body)

        return response
        
        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
    }
    
    app.get("games", ":id", "cells") { req -> String in

        guard let id = req.parameters.get("id", as: Int.self),
              let board = boardController.getExistingBoard(id: id) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }
        
        guard let rawFilter: String = req.query["filter"],
              // filter not fully implemented yet! TODO: change _ to filter as name of variable
              let _ : Filter = Filter(rawValue: rawFilter) else {
            throw Abort(.badRequest, reason: "The filter specified doesn't match the requirements.")
        }

        guard let data = try? encoder.encode(board),
              let json = String(data: data, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "There was a problem with returning back the board to you!")
        }
        
        return json
    }

    // * Action: Place specified value at in game at boxIndex, cellIndex
    // * Payload: value (null for removing value)
    // * Response: Nothing
    // * Status: 204 No Content
    
    
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        /* retrieve parameterized endpoints as strings and convert to int accordingly */

        guard let id = req.parameters.get("id", as: Int.self),
              let boxIndex = req.parameters.get("boxIndex", as: Int.self),
              let cellIndex = req.parameters.get("cellIndex", as: Int.self),
              let cellValue = try? req.content.decode(CellValue.self) else {
             throw Abort(.badRequest, reason: "Failed to encode boxIndex, cellIndex or cellValue")

             
            } 

        /*******testing...
        let diff = Difficulty.easy
        idTable[id]?.setDifficulty(difficulty:diff)
        idTable[id]?.setModifiableVal()
         */

        /* setting value */
        boardController.setCellValue(id: id, boxIndex:boxIndex, cellIndex:cellIndex, value:cellValue.value)
      
        return HTTPStatus.noContent
    }
}
