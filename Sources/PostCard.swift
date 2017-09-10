//
//  PostCard.swift
//  BraillePostCard
//
//  Created by Myoungwoo Jang on 10/09/2017.
//
//

import Foundation

class Person {
    var name: String = ""
    var address: String = ""
}

class PostCard {
    let from: Person
    let to  : Person
    let message: [String]
    let title: String
    let ID: Int
    
    init() {
        // default
        from = Person()
        to   = Person()
        from.name = "MW"
        from.address="Heaven"
        to.name = "Angel"
        to.address = "earth"
        title = "Lovely Message To you"
        message = ["i", "love", "you"]
        ID = 0
    }
    
    init(postCardJSON: [String:Any]?) {
        from = Person()
        to   = Person()
        
        title = postCardJSON?["title"] as? String ?? "Undefined"
        let fromJSON = postCardJSON?["from"] as? [String:Any]
        from.name    = fromJSON?["name"] as? String ?? "Undefined"
        from.address = fromJSON?["address"] as? String ?? "Undefined"
        
        let toJSON = postCardJSON?["to"] as? [String:Any]
        from.name    = toJSON?["name"] as? String ?? "Undefined"
        from.address = toJSON?["address"] as? String ?? "Undefined"
        
        message = (postCardJSON?["message"] as? [String])!
        ID = 0

        print(String(describing: self))
        print("여기서부터 ")
        for (key, value) in postCardJSON! {
            print("\(key) : \(value)")
        }
    }
    
}
