//
//  main.swift
//
//  BraillePostCard
//
//  Created by Myoungwoo Jang on 10/09/2017.
//


import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.setBody(string: "Hello, Perfect!")
        .completed()
})

func returnJSONMessage(message: String, response: HTTPResponse) {
    do {
        try response.setBody(json: ["message", message])
            .setHeader(.contentType, value: "application/json")
            .completed()
    } catch {
        response.setBody(string: "Error handling request: \(error)")
            .completed(status: .internalServerError)
    }
}

routes.add(method: .get, uri: "/hello", handler: {
    request, response in
    returnJSONMessage(message: "Hello, JSON", response: response)
})

routes.add(method: .get, uri: "/hello/there", handler: {
    request, response in
    returnJSONMessage(message: "I am tired of saying hello", response: response)
})

routes.add(method: .get, uri: "/beers/{num_beers}", handler: {
    request, response in
    guard let numBeersString = request.urlVariables["num_beers"],
        let numBeersInt = Int(numBeersString) else {
            response.completed(status: .badRequest)
            return
    }
    returnJSONMessage(message: "Take one down pass it around, \(numBeersInt - 1) bottles of beer on the wal'...", response: response)
})

routes.add(method: .post, uri: "post", handler: {
    request, response in
    guard let name = request.param(name: "name") else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: "Hello, \(name)", response: response)
})

routes.add(method: .post, uri: "/api/json", handler: {
    request, response in
    do {
        if let body = request.postBodyString {
                
            let json = try body.jsonDecode() as? [String:Any]
            
            let title = json?["title"] as? String ?? "Undefined"
            let from = json?["from"] as? [String:Any]
            let name = from?["name"] as? String ?? "Undefined"
            
            let postCard = PostCard(postCardJSON: json)
            //TODO
            // Call : Make Call
            let brailleTranslater = BrailleTranslater(postCard: postCard)
            brailleTranslater.convert(target: "all")
            //
            try response.setBody(json: [
                "name": "\(name)",
                "title": "\(title)",
                "message": "Your message will be made as Braill STL & Gcode"
            ])
        } else {
            try response.setBody(json: ["message":"Hello, World! I can personalize this if you let me?"])
        }
    } catch {
        print(error)
    }

    response.setHeader(.contentType, value: "application/json")
    response.completed()
    }
)

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
