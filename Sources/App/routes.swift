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
        var boardId : Int = -1

        let rawBoardId = req.parameters.get("id")
        convertOptionalStringToInteger(stringToConvert: rawBoardId, integer: &boardId)
              
        return "games/id/cells endpoint works"

        // * Action: None
        // * Payload: None
        // * Response: cells
        // * Status code: 200 OK
    }

    app.put("games", ":id", "cells", ":boxIndex", ":cellIndex") { req -> String in
        var boardId : Int = -1
        var boxIndex : Int = -1
        var cellIndex : Int = -1
        
        let rawBoardId = req.parameters.get("id")
        convertOptionalStringToInteger(stringToConvert: rawBoardId, integer: &boardId)
        
        let rawBoxIndex = req.parameters.get("boxIndex")
        convertOptionalStringToInteger(stringToConvert: rawBoxIndex, integer: &boxIndex)

        let rawCellIndex = req.parameters.get("cellIndex")
        convertOptionalStringToInteger(stringToConvert: rawCellIndex, integer: &cellIndex)   
        
        return "games/id/cells/boxIndex/cellIndex endpoint works"
        
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
