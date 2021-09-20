import Vapor

struct CellValue : Content {
    let id : String
    let boxIndex : Int
    let cellIndex : Int
}

struct BoardValues : Content {
    let board : [[Int]]
}


func routes(_ app: Application) throws {
    app.get { req in
        return "Server side working!"
    }



    
    // * Action: Creates a new game and associated board
    // * Payload: None
    // * Response: Id uniquely identifying a game
    // * Status code: 201 Created
    
    app.post("games") { req -> String in
        /* do board setup here */
        let board = Board()
        board.fillBoard()
        /* do unique identification here */
        let uuid = UUID().uuidString
        /* assign board to id on the idTable */
        idTable[uuid] = board
        return uuid
    }

    // * Action: None
    // * Payload: None
    // * Response: cells
    // * Status code: 200 OK
    
    app.get("games", ":id", "cells") { req -> String in
        let id = req.parameters.get("id")!
        //let board = BoardValues()
        //board.board = idTable[id]?.getBoard()

        // 2d array cannot be converted to string directly via swift functions or content class!!!!!
        let json = idTable[id]?.jsonBoard() ?? "error"
        return json
    }

    // * Action: Place specified value at in game at boxIndex, cellIndex
    // * Payload: value (null for removing value)
    // * Response: Nothing
    // * Status: 204 No Content
    
    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> CellValue  in

        // "cellAssign" contains the Cell value content sent from the client to server
        let cellAssign = try req.content.decode(CellValue.self)

        // setting value
        idTable[cellAssign.id]?.setVal(row:1, col:2, val:3)
        
        return cellAssign
    }
}
