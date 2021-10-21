import Vapor

/*
 TODO
 - json decoding
 - property and function access modifiers (public/private)
 - filter implementation (and board validation method)
 */

let boardController = BoardController()

let encoder = JSONEncoder()
let decoder = JSONDecoder()

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

        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
        
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
        

    }
    
    app.get("games", ":id", "cells") { req -> Response in

        // * Action: None
        // * Payload: None
        // * Response: cells
        // * Status code: 200 OK
        
        guard let rawFilter: String = req.query["filter"],
              // filter not fully implemented yet! TODO: change _ to filter as name of variable
              let _ : Filter = Filter(rawValue: rawFilter) else {
            throw Abort(.badRequest, reason: "The filter specified doesn't match the requirements.")
        }

        guard let id = req.parameters.get("id", as: Int.self),
              let board = boardController.getExistingBoard(id: id) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }

        guard let data = try? encoder.encode(board),
              let json = String(data: data, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "There was a problem with returning back the board to you!")
        }

        let body = Response.Body(string: json)
        let response = Response(status: .ok, body: body)
        
        return response
    }   
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        // * Action: Place specified value at in game at boxIndex, cellIndex
        // * Payload: value (null for removing value)
        // * Response: Nothing
        // * Status: 204 No Content
        
        guard let id = req.parameters.get("id", as: Int.self),
              let boxIndex = req.parameters.get("boxIndex", as: Int.self),
              let cellIndex = req.parameters.get("cellIndex", as: Int.self),
              let cellValue = try? req.content.decode(CellValue.self) else {
            throw Abort(.badRequest, reason: "Failed to encode boxIndex, cellIndex or cellValue")             
        } 

        boardController.setCellValue(id: id, boxIndex:boxIndex, cellIndex:cellIndex, value:cellValue.value)
        
        return HTTPStatus.noContent
    }
}
