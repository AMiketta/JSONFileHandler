# JSONFileHandler

Description:
The JSON File handler can load JSON files from the resources and decode them to the target class.

Usage:
let handler = JSONFileHandler<MyType>()
        handler.loadData(ressource: "RessourceName") { (myResult) in
            // Your Code Here
        }
