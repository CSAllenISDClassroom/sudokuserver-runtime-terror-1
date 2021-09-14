import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.post("games") { req -> String in
        return "games endpoint works"

        // * Action: Creates a new game and associated board
        // * Payload: None
        // * Response: Id uniquely identifying a game
        // * Status code: 201 Created
    }

    app.get("games", ":id", "cells") { req -> String in
        print(req.parameters.get("id")!)
        return "games/id/cells endpoint works"

        // * Action: None
        // * Payload: None
        // * Response: cells
        // * Status code: 200 OK
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> String in
        print(req.parameters.get("id")!)
        print(req.parameters.get("boxIndex")!)
        print(req.parameters.get("cellIndex")!)

        // test package and class access
        let board = Board()
                
        return "games/id/cells/boxIndex/cellIndex endpoint works"
        
        // * Action: Place specified value at in game at boxIndex, cellIndex
        // * Payload: value (null for removing value)
        // * Response: Nothing
        // * Status: 204 No Content
    }
}
