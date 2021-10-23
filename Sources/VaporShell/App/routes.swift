import Vapor

let boardController = BoardController()
let encoder = JSONEncoder()
let decoder = JSONDecoder()

struct CellValue : Codable {
    let value : Int
}

struct BoardId: Codable {
    let id: Int
}

func routes(_ app: Application) throws {
    app.get { req in
        return  "Server side working!"
    }

    /* initial board setup for a user */
    app.post("games") { req -> Response in
        
        /* generate and fill a new board */
        let id = boardController.getNewBoard()
        
        /* assign difficulty */
        guard let rawDifficulty: String = req.query["difficulty"],
              let difficulty = Difficulty(rawValue: rawDifficulty) else {
            throw Abort(.badRequest, reason: "Difficulty specified doesn't match requirements.")
        }
        boardController.setDifficulty(id:id, difficulty: difficulty)

        /* assign id as json through header and define response code to data */
        let constructedId = BoardId(id: id)
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

    app.get("games", ":id", "cells") { req -> String in

        /* retrieve parameterized id endpoint */
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }        
        
        /* getting filtered values into board data structure */
        guard let rawFilter: String = req.query["filter"],
              let filter : Filter = Filter(rawValue: rawFilter) else {
            throw Abort(.badRequest, reason: "The filter specified doesn't match the requirements.")
        }
        let boardData = boardController.getFilteredCells(id: id, filter: filter)

        /* data structure encoded into json */
        guard let json = try? boardController.jsonBoard(board:boardData) else {
            throw Abort(.badRequest, reason: "Failed to encode Board to Json")
        }
        return json
    }
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> HTTPStatus in

        /* retrieve parameterized endpoints as strings and convert to int accordingly */
          guard let id = req.parameters.get("id", as: Int.self),
              (boardController.isExistingBoard(id: id)) else {
            throw Abort(.badRequest, reason: "The board with the specified id could not be found.")
        }

        guard let boxIndex = req.parameters.get("boxIndex", as: Int.self),
              ((0...8).contains(boxIndex)) else {
            throw Abort(.badRequest, reason: "The boxIndex must be in range 0 ... 8")
        }

        guard let cellIndex = req.parameters.get("cellIndex", as: Int.self),
              ((0...8).contains(cellIndex)) else {
            throw Abort(.badRequest, reason: "The cellIndex must be in range 0 ... 8")
        }

        guard let json : String = req.body.string,
              let data = json.data(using: .utf8),
              let cellValue = try? decoder.decode(CellValue.self, from: data) else {
            throw Abort(.badRequest, reason: "The JSON received doesn't match the requirements.")
        }

        if !(1...9).contains(cellValue.value) {
            throw Abort(.badRequest, reason: "The cell value must be null or in range 1 ... 9")
        }

        print(id, boxIndex, cellIndex, cellValue.value)
        /* setting value */
        let board = boardController.getExistingBoard(id:id)
        board?.setVal(boxIndex:boxIndex, cellIndex:cellIndex, val:cellValue.value)
      
        return HTTPStatus.ok
    }
}
