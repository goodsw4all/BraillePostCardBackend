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
    let ID: Int
    
    init() {
        // default
        from = Person()
        to   = Person()
        from.name = "MW"
        from.address="Heaven"
        to.name = "Angel"
        to.address = "earth"
        message = ["i", "love", "you"]
        ID = 0
    }
}
