import Vapor
import Foundation

/*
 TODO
 - crash/fatalError thorough prevention checking + implementation
 */

let boardController = BoardController()

let encoder = JSONEncoder()
let decoder = JSONDecoder()

public func routes(_ app: Application) throws {
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
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        let response = Response(status: .created, headers: headers, body: body)

        return response
        

    }
    
    app.get("games", ":id", "cells") { req -> Response in

        // * Action: None
        // * Payload: None
        // * Response: cells
        // * Status code: 200 OK
        
        guard let rawFilter: String = req.query["filter"],
              let filter : Filter = Filter(rawValue: rawFilter) else {
            throw Abort(.badRequest, reason: "The filter specified doesn't match the requirements.")
        }

        guard let id = req.parameters.get("id", as: Int.self),
              let board = boardController.getExistingBoard(id: id, filter: filter) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }

        guard let data = try? encoder.encode(board),
              let json = String(data: data, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "There was a problem with returning back the board to you!")
        }

        let body = Response.Body(string: json)
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        let response = Response(status: .ok, headers: headers, body: body)
        
        return response
    }   
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        // * Action: Place specified value at in game at boxIndex, cellIndex
        // * Payload: value (null for removing value)
        // * Response: Nothing
        // * Status: 204 No Content

        guard let id = req.parameters.get("id", as: Int.self),
              let _ = boardController.getExistingBoard(id: id, filter: .all) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }

        let boxIndexErrorReason = "The boxIndex must be in range 0 ... 8"
        let cellIndexErrorReason = boxIndexErrorReason.replacingOccurrences(of: "boxIndex", with: "cellIndex")
        
        guard let boxIndex = req.parameters.get("boxIndex", as: Int.self) else {
            throw Abort(.badRequest, reason: boxIndexErrorReason)
        }

        if(!(0...8).contains(boxIndex)) {
            throw Abort(.badRequest, reason: boxIndexErrorReason)
        }

        guard let cellIndex = req.parameters.get("cellIndex", as: Int.self) else {
            throw Abort(.badRequest, reason: cellIndexErrorReason)
        }

        if(!(0...8).contains(cellIndex)) {
            throw Abort(.badRequest, reason: cellIndexErrorReason)
        }
        
        guard let json : String = req.body.string,
              let data = json.data(using: .utf8),
              let cellValue = try? decoder.decode(CellValue.self, from: data) else {
            throw Abort(.badRequest, reason: "The JSON received doesn't match the requirements.")
        }

        if(!cellValue.checkValue()) {
            throw Abort(.badRequest, reason: "The cell value must be null or in range 1 ... 9")
        }
        let value = cellValue.value

        boardController.setCellValue(id: id, boxIndex:boxIndex, cellIndex:cellIndex, value: value)
        
        return HTTPStatus.noContent
    }
}
